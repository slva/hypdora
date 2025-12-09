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

## 📁 Estructura de fitxers

```
~/.config/
├── hypr/
│   ├── hyprland.conf     # Configuració principal
│   ├── bindings.conf     # Keybindings personalitzats
│   ├── monitors.conf     # Configuració de monitors
│   └── ...
├── waybar/
│   ├── config.jsonc
│   └── style.css
├── walker/
│   └── config.toml
└── mako/
    └── config

~/.local/share/omarchy-fedora/
├── default/              # Configuracions per defecte
├── bin/                  # Scripts d'utilitat
└── themes/               # Temes
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
