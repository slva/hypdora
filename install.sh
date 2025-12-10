#!/bin/bash
# Omarchy Fedora - Port d'Omarchy per a Fedora Linux
# Només inclou Hyprland i les seves extensions/configuracions

set -eEo pipefail

# Colors per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Paths
export OMARCHY_FEDORA_PATH="$HOME/.local/share/omarchy-fedora"
export OMARCHY_FEDORA_CONFIG="$HOME/.config"
export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logo ASCII
show_logo() {
    echo -e "${CYAN}"
    cat << 'EOF'
   ____                           _           
  / __ \____ ___  ____ __________(_)____  __  
 / / / / __ `__ \/ __ `/ ___/ ___/ / __  / / / 
/ /_/ / / / / / / /_/ / /  / /__/ / / / / /_/ / 
\____/_/ /_/ /_/\__,_/_/   \___/_/_/ /_/\__, /  
                                       /____/   
          Fedora Edition
EOF
    echo -e "${NC}"
}

# Funcions d'utilitat
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estem a Fedora
check_fedora() {
    if [[ ! -f /etc/fedora-release ]]; then
        log_error "Aquest script només funciona a Fedora Linux"
        exit 1
    fi
    
    FEDORA_VERSION=$(rpm -E %fedora)
    log_info "Detectat Fedora $FEDORA_VERSION"
}

# Demanar confirmació
confirm() {
    read -p "$1 [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Instal·lar repositoris COPR
install_copr_repos() {
    log_info "Afegint repositoris COPR per Hyprland..."
    
    # COPR de solopasha per Hyprland i components
    if ! dnf repolist | grep -q "solopasha-hyprland"; then
        sudo dnf copr enable -y solopasha/hyprland
        log_success "Repositori COPR solopasha/hyprland afegit"
    else
        log_info "Repositori COPR solopasha/hyprland ja existeix"
    fi
    
    # COPR per Walker
    if ! dnf repolist | grep -q "errornointernet-walker"; then
        sudo dnf copr enable -y errornointernet/walker
        log_success "Repositori COPR errornointernet/walker afegit"
    else
        log_info "Repositori COPR errornointernet/walker ja existeix"
    fi
    
    # COPR per SwayOSD
    if ! dnf repolist | grep -q "erikreider-swayosd"; then
        sudo dnf copr enable -y erikreider/swayosd
        log_success "Repositori COPR erikreider/swayosd afegit"
    else
        log_info "Repositori COPR erikreider/swayosd ja existeix"
    fi
}

# Instal·lar paquets
install_packages() {
    log_info "Instal·lant paquets necessaris..."
    
    # Paquets base de Fedora
    FEDORA_PACKAGES=(
        # Hyprland i components
        hyprland
        hypridle
        hyprlock
        hyprpicker
        xdg-desktop-portal-hyprland
        
        # Barra d'estat i notificacions
        waybar
        mako
        
        # Wallpapers i OSD
        swaybg
        swayosd
        
        # Utilitats Wayland
        wl-clipboard
        grim
        slurp
        brightnessctl
        playerctl
        pamixer
        
        # Launcher
        walker
        
        # Polkit (mate-polkit - GTK based, no Qt conflicts)
        mate-polkit
        
        # Fonts
        jetbrains-mono-fonts-all
        google-noto-sans-fonts
        google-noto-emoji-fonts
        fontawesome-fonts-all
        # Nerd Fonts (necessari per moltes icones)
        google-noto-sans-mono-nerd-fonts
        
        # Terminal (ghostty no disponible, alternatives)
        alacritty
        
        # Utilitats generals
        jq
        fzf
        ripgrep
        fd-find
        bat
        
        # Keyring
        gnome-keyring
        
        # Hyprland Qt Utils (Removed due to dependency conflict on Fedora 43)
        # hyprland-qtutils
    )
    
    log_info "Actualitzant sistema..."
    sudo dnf update -y
    
    log_info "Instal·lant paquets..."
    sudo dnf install -y "${FEDORA_PACKAGES[@]}"
    
    # Intentar instal·lar hyprsunset (pot no estar disponible)
    sudo dnf install -y hyprsunset 2>/dev/null || log_warning "hyprsunset no disponible"
    
    log_success "Paquets instal·lats correctament"
}

# Crear directoris base
create_directories() {
    log_info "Creant directoris base..."
    
    # Només crear els directoris pare, els symlinks crearan la resta
    mkdir -p "$OMARCHY_FEDORA_PATH"
    mkdir -p "$OMARCHY_FEDORA_CONFIG"
    
    log_success "Directoris creats"
}

# Crear symlinks per configuracions (dotfiles)
link_configs() {
    log_info "Creant symlinks per configuracions..."
    
    # Assegurar paths absoluts
    local REPO_DIR="$SCRIPT_DIR"
    
    # Guardar el path del repositori per referència
    mkdir -p "$OMARCHY_FEDORA_CONFIG/omarchy-fedora"
    echo "$REPO_DIR" > "$OMARCHY_FEDORA_CONFIG/omarchy-fedora/.dotfiles-path"
    
    # Funció per crear symlink amb backup i verificació
    create_symlink() {
        local source="$1"
        local target="$2"
        
        # Verificar source
        if [[ ! -e "$source" ]]; then
            log_error "Font no trobada: $source"
            return 1
        fi
        
        # Si existeix i no és symlink, fer backup
        if [[ -e "$target" && ! -L "$target" ]]; then
            local backup_name="$target.backup.$(date +%Y%m%d_%H%M%S)"
            log_warning "Backup: $target -> $backup_name"
            mv "$target" "$backup_name"
        fi
        
        # Eliminar symlink existent (per assegurar que s'actualitza)
        if [[ -L "$target" ]]; then
            rm "$target"
        fi
        
        # Crear directori pare si no existeix
        local parent_dir=$(dirname "$target")
        if [[ ! -d "$parent_dir" ]]; then
            mkdir -p "$parent_dir"
        fi
        
        # Crear symlink
        if ln -sf "$source" "$target"; then
            log_info "Symlink creat: $target -> $source"
        else
            log_error "Error creant symlink: $target"
            return 1
        fi
    }
    
    # Symlink per default configs
    create_symlink "$REPO_DIR/default" "$OMARCHY_FEDORA_PATH/default"
    
    # Symlink per bin scripts
    create_symlink "$REPO_DIR/bin" "$OMARCHY_FEDORA_PATH/bin"
    chmod +x "$REPO_DIR/bin/"*
    
    # Symlink per themes
    create_symlink "$REPO_DIR/config/themes" "$OMARCHY_FEDORA_PATH/themes"
    
    # Symlinks per configs d'usuari
    for dir in hypr waybar walker mako; do
        if [[ -d "$REPO_DIR/config/$dir" ]]; then
            create_symlink "$REPO_DIR/config/$dir" "$OMARCHY_FEDORA_CONFIG/$dir"
        fi
    done
    
    # Crear symlink per tema actual (directament al repo per evitar problemes de chaining)
    if ln -sf "$REPO_DIR/config/themes/default" "$OMARCHY_FEDORA_CONFIG/omarchy-fedora/current"; then
        log_info "Symlink tema creat: $OMARCHY_FEDORA_CONFIG/omarchy-fedora/current -> $REPO_DIR/config/themes/default"
    else
        log_error "Error creant symlink del tema"
    fi
    
    log_success "Symlinks creats i verificats"
}

# Setup PATH
setup_path() {
    log_info "Configurant PATH..."
    
    BASHRC="$HOME/.bashrc"
    PATH_LINE='export PATH="$HOME/.local/share/omarchy-fedora/bin:$PATH"'
    
    if ! grep -q "omarchy-fedora/bin" "$BASHRC" 2>/dev/null; then
        echo "" >> "$BASHRC"
        echo "# Omarchy Fedora" >> "$BASHRC"
        echo "$PATH_LINE" >> "$BASHRC"
        log_success "PATH afegit a .bashrc"
    else
        log_info "PATH ja configurat"
    fi
    
    # També per zsh si existeix
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "omarchy-fedora/bin" "$HOME/.zshrc" 2>/dev/null; then
            echo "" >> "$HOME/.zshrc"
            echo "# Omarchy Fedora" >> "$HOME/.zshrc"
            echo "$PATH_LINE" >> "$HOME/.zshrc"
            log_success "PATH afegit a .zshrc"
        fi
    fi
}

# Habilitar serveis
enable_services() {
    log_info "Habilitant serveis..."
    
    # Bluetooth (si hi ha hardware)
    if [[ -d /sys/class/bluetooth ]]; then
        sudo systemctl enable --now bluetooth 2>/dev/null || true
    fi
    
    log_success "Serveis configurats"
}

# Crear entrada de sessió per SDDM/GDM
create_session_entry() {
    log_info "Creant entrada de sessió Hyprland..."
    
    # Verificar si ja existeix
    if [[ -f /usr/share/wayland-sessions/hyprland.desktop ]]; then
        log_info "Entrada de sessió Hyprland ja existeix"
        return
    fi
    
    # Si no existeix, crear-la (requereix sudo)
    sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
    
    log_success "Entrada de sessió creada"
}

# Mostrar missatge final
show_final_message() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Omarchy Fedora instal·lat correctament!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Pròxims passos:${NC}"
    echo "  1. Reinicia el sistema"
    echo "  2. Al login manager (GDM/SDDM), selecciona 'Hyprland'"
    echo "  3. Utilitza Super+Return per obrir una terminal"
    echo "  4. Utilitza Super+Space per obrir el launcher"
    echo ""
    echo -e "${CYAN}Keybindings principals:${NC}"
    echo "  Super + Return     Terminal"
    echo "  Super + Space      Launcher (walker)"
    echo "  Super + W          Tancar finestra"
    echo "  Super + F          Pantalla completa"
    echo "  Super + 1-0        Canviar workspace"
    echo "  Super + Shift+1-0  Moure finestra a workspace"
    echo "  Print              Captura de pantalla"
    echo ""
    echo -e "${YELLOW}Nota:${NC} Recorda executar 'source ~/.bashrc' o obrir una nova terminal"
    echo ""
}

# Main
main() {
    show_logo
    echo "Installer Version: 2.1 (Timestamp Fix)"
    
    echo -e "${CYAN}Benvingut a l'instal·lador d'Omarchy Fedora!${NC}"
    echo ""
    echo "Aquest script instal·larà:"
    echo "  - Hyprland (compositor Wayland)"
    echo "  - Waybar (barra d'estat)"
    echo "  - Walker (launcher d'aplicacions)"
    echo "  - Mako (notificacions)"
    echo "  - Hypridle/Hyprlock (idle i lock screen)"
    echo "  - Configuracions i temes d'Omarchy"
    echo ""
    
    if ! confirm "Vols continuar?"; then
        log_info "Instal·lació cancel·lada"
        exit 0
    fi
    
    echo ""
    
    check_fedora
    install_copr_repos
    install_packages
    create_directories
    link_configs
    setup_path
    enable_services
    create_session_entry
    show_final_message
}

main "$@"
