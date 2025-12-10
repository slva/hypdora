# Omarchy Fedora

Port de l'experiència d'usuari d'[Omarchy](https://github.com/basecamp/omarchy) per a **Fedora Linux**.

Aquest projecte porta les configuracions de Hyprland, Waybar, i altres components d'Omarchy a Fedora, permetent tenir la mateixa experiència d'usuari sense haver d'instal·lar una distribució diferent.

## 📋 Què inclou

- **Hyprland** - Compositor Wayland amb tiling dinàmic
- **Waybar** - Barra d'estat moderna
- **Walker** - Launcher d'aplicacions (GTK4)
- **Mako** - Sistema de notificacions
- **Hypridle** - Gestió d'idle (estalvi d'energia)
- **Hyprlock** - Pantalla de bloqueig
- **Configuracions i keybindings** estil Omarchy
- **Tema per defecte**

## 🚀 Instal·lació

```bash
git clone https://github.com/YOUR_USERNAME/omarchy-fedora.git
cd omarchy-fedora
chmod +x install.sh
./install.sh
```

## ⌨️ Keybindings principals

| Keybinding | Acció |
|------------|-------|
| `Super + Return` | Obrir terminal |
| `Super + Space` | Launcher (walker) |
| `Super + W` | Tancar finestra |
| `Super + F` | Pantalla completa |
| `Super + T` | Toggle floating |
| `Super + 1-0` | Canviar a workspace 1-10 |
| `Super + Shift + 1-0` | Moure finestra a workspace |
| `Super + Arrow Keys` | Moure focus |
| `Super + Shift + Arrow` | Moure finestra |
| `Print` | Captura de pantalla |
| `Super + Escape` | Menú del sistema |

## 📁 Estructura de fitxers (Dotfiles)

Aquest projecte utilitza **symlinks** per gestionar les configuracions. Això permet:
- Editar directament al repositori i veure els canvis immediatament
- Versionar les configs amb Git
- Sincronitzar fàcilment entre màquines

```
~/code/hypfedora/           # El teu repositori (pot estar on vulguis)
├── config/                  # -> symlink a ~/.config/
│   ├── hypr/
│   ├── waybar/
│   ├── walker/
│   └── mako/
├── default/                 # -> symlink a ~/.local/share/omarchy-fedora/default/
└── bin/                     # -> symlink a ~/.local/share/omarchy-fedora/bin/

~/.config/hypr               # Symlink -> ~/code/hypfedora/config/hypr
~/.config/waybar             # Symlink -> ~/code/hypfedora/config/waybar
~/.local/share/omarchy-fedora/
├── default -> ~/code/hypfedora/default
├── bin -> ~/code/hypfedora/bin
└── themes -> ~/code/hypfedora/config/themes
```

## 🎨 Personalització

### Modificar keybindings

Edita `~/.config/hypr/bindings.conf` per afegir o modificar keybindings.

### Canviar wallpaper

```bash
# Copia el teu wallpaper
cp el_teu_wallpaper.jpg ~/.config/omarchy-fedora/current/background

# O modifica swaybg a autostart
```

### Modificar Waybar

Edita `~/.config/waybar/config.jsonc` i `~/.config/waybar/style.css`.

## 📦 Dependències

Paquets instal·lats automàticament:

- hyprland, hypridle, hyprlock, hyprpicker
- waybar, mako, swaybg, swayosd
- walker, wl-clipboard, grim, slurp
- brightnessctl, playerctl, pamixer
- alacritty (terminal)
- Fonts: JetBrains Mono, Noto, FontAwesome

## 🔄 Sincronització entre màquines

Com que el projecte usa symlinks, pots sincronitzar configs fàcilment:

```bash
# En una nova màquina
git clone https://github.com/YOUR_USERNAME/hypfedora.git ~/dotfiles/hypfedora
cd ~/dotfiles/hypfedora
./install.sh

# Actualitzar configs
cd ~/dotfiles/hypfedora
git pull  # Els canvis s'apliquen automàticament (symlinks!)
```

## 🔧 Resolució de problemes

### Hyprland no apareix al login manager

```bash
# Verificar que existeix l'entrada de sessió
ls /usr/share/wayland-sessions/hyprland.desktop
```

### Waybar no mostra icones

```bash
# Instal·lar fonts d'icones
sudo dnf install fontawesome-fonts-all
```

### El launcher no funciona

```bash
# Provar walker directament
walker
```

## 📄 Llicència

MIT License - basat en [Omarchy](https://github.com/basecamp/omarchy) de Basecamp.

## 🙏 Crèdits

- [Omarchy](https://github.com/basecamp/omarchy) per DHH i Basecamp
- [Hyprland](https://hyprland.org/) per vaxry
- Comunitat Fedora
