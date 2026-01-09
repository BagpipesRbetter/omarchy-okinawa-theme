# Okinawa - The Beach Episode 🌊

> *Imagine that beach trip to Okinawa in your favorite anime. That's this theme. Oceanic blues, calming vibes, and a complete visual overhaul for your Omarchy setup.*

This is a comprehensive theme for **Omarchy** that provides a cohesive "Okinawa Blue" aesthetic across your window manager, terminal, editor, and system bars.

## 🚀 Installation

### Option 1: The Easy Way (Recommended)
We provide an automated installation script that handles the theme, wallpapers, and optional music setup.

1.  Clone the repository (if you haven't already):
    ```bash
    git clone https://github.com/BagpipesRbetter/omarchy-okinawa-theme.git
    cd omarchy-okinawa-theme
    ```
2.  Run the installer:
    ```bash
    ./install.sh
    ```
    *   **Theme**: Installs core configurations.
    *   **Music**: Optionally installs/enables `mpd`, `rmpc`, and `mpd-mpris`.
    *   **Wallpapers**: Optionally copies wallpapers to `~/Pictures/Wallpapers/Omarchy`.
    *   **Waybar/RMPC**: Backs up and installs custom layouts.

### Option 2: Via Omarchy CLI
If you only want the base theme configuration without the extras:
```bash
omarchy-theme-install https://github.com/BagpipesRbetter/omarchy-okinawa-theme
```

---

## 🎨 Theme Details

### 🖥️ Window Manager (Hyprland)
*   **Colors**: Deep ocean blue background (`#182538`) with "Sky Blue" active borders (`#5aa3d2`).
*   **Layout**: Dwindle layout enabled.
*   **Gaps**: Inner: 4px, Outer: 8px.
*   **Decoration**: Rounded corners (8px), soft shadows.
*   **Animations**: Custom "Okinawa" bezier curves for smooth, relaxing window movements.

### 📊 Status Bar (Waybar)
*   **Design**: Completely custom pill-shaped layout.
*   **Modules**:
    *   **Custom RMPC/MPRIS**: specialized music controls.
    *   **Tray Expander**: Hides tray icons for a cleaner look.
    *   **Date/Time**: Custom formatting.
    *   **Battery/Network**: Themed icons.

### 🐚 Terminal & Editors
Consistent color palette applied to:
*   **Terminals**: Alacritty, Kitty, Ghostty.
*   **Neovim**: Customized `tokyonight-night` flavor with specific overrides for the Okinawa palette.
*   **VSCode**: Full workbench color customizations matching the system theme.
*   **Mako**: Notification daemon styled to match.

---

## 🎵 Extras & Music Setup

The `install.sh` script can set up a complete audiophile music environment for you.

### Components
*   **MPD (Music Player Daemon)**: The core music server.
*   **RMPC**: A beautiful, rust-based TUI client for MPD. We include a custom Okinawa theme for it.
*   **MPD-MPRIS**: Integrates MPD with system media controls (play/pause keys, waybar modules).

### Manual Music Setup
If you didn't use the installer, you can set this up manually:
1.  Install packages: `mpd`, `rmpc`, `mpd-mpris`.
2.  Enable services:
    ```bash
    systemctl --user enable --now mpd
    systemctl --user enable --now mpd-mpris
    ```
3.  Copy the custom RMPC config:
    ```bash
    cp -r custom/rmpc ~/.config/
    chmod +x ~/.config/rmpc/Scripts/songchange.sh
    ```

---

## 🖼️ Wallpapers
A collection of 5 curated "Okinawa" aesthetic wallpapers are included in the `backgrounds/` folder. The installer can automatically place them in your `~/Pictures/Wallpapers/Omarchy` directory.
