#!/bin/bash

# Omarchy Okinawa Theme Installer
# This script automates the installation of the Okinawa theme and its extras.

set -e

THEME_NAME="okinawa"
INSTALL_DIR="$HOME/.config/omarchy/themes/$THEME_NAME"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/omarchy/backups/$(date +%Y%m%d_%H%M%S)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Ensure we are in the right directory or find the source files
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log_info "Starting installation for Omarchy Okinawa Theme..."

# 1. Install Base Theme Files
log_info "Installing base theme files to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
cp -r "$SOURCE_DIR/"* "$INSTALL_DIR/"
log_success "Base theme files installed."

# 2. Install RMPC Theme (Extra)
if [ -d "$SOURCE_DIR/custom/rmpc" ]; then
    echo -e "\nDo you want to install the custom RMPC (MPD Client) theme? [y/N]"
    read -r install_rmpc
    if [[ "$install_rmpc" =~ ^[Yy]$ ]]; then
        log_info "Installing RMPC theme..."
        
        # Backup
        if [ -d "$CONFIG_DIR/rmpc" ]; then
            mkdir -p "$BACKUP_DIR"
            log_warning "Backing up existing rmpc config to $BACKUP_DIR/rmpc"
            cp -r "$CONFIG_DIR/rmpc" "$BACKUP_DIR/"
        fi

        # Copy
        mkdir -p "$CONFIG_DIR/rmpc"
        cp -r "$SOURCE_DIR/custom/rmpc/"* "$CONFIG_DIR/rmpc/"
        
        # Make script executable
        if [ -f "$CONFIG_DIR/rmpc/Scripts/songchange.sh" ]; then
            chmod +x "$CONFIG_DIR/rmpc/Scripts/songchange.sh"
            log_info "Made songchange.sh executable."
        fi
        
        log_success "RMPC theme installed."
    else
        log_info "Skipping RMPC theme installation."
    fi
fi

# 3. Install Custom Waybar Layout (Extra)
if [ -d "$SOURCE_DIR/custom/waybar" ]; then
    echo -e "\nDo you want to install the custom Waybar layout? [y/N]"
    read -r install_waybar
    if [[ "$install_waybar" =~ ^[Yy]$ ]]; then
        log_info "Installing Custom Waybar layout..."
        
        # Backup
        if [ -d "$CONFIG_DIR/waybar" ]; then
            mkdir -p "$BACKUP_DIR"
            log_warning "Backing up existing waybar config to $BACKUP_DIR/waybar"
            cp -r "$CONFIG_DIR/waybar" "$BACKUP_DIR/"
        fi

        # Copy
        mkdir -p "$CONFIG_DIR/waybar"
        cp -r "$SOURCE_DIR/custom/waybar/"* "$CONFIG_DIR/waybar/"
        
        log_success "Custom Waybar layout installed."
    else
        log_info "Skipping Custom Waybar layout installation."
    fi
fi

# 4. Install Backgrounds
if [ -d "$SOURCE_DIR/backgrounds" ]; then
    echo -e "\nDo you want to install the wallpapers? [y/N]"
    read -r install_bg
    if [[ "$install_bg" =~ ^[Yy]$ ]]; then
        BG_DIR="$HOME/Pictures/Wallpapers/Omarchy"
        log_info "Installing wallpapers to $BG_DIR..."
        mkdir -p "$BG_DIR"
        cp -r "$SOURCE_DIR/backgrounds/"* "$BG_DIR/"
        log_success "Wallpapers installed."
    else
        log_info "Skipping wallpaper installation."
    fi
fi

# 5. Install Music Setup
echo -e "\nDo you want to install the music setup (mpd, rmpc, mpd-mpris) and enable services? [y/N]"
read -r install_music
if [[ "$install_music" =~ ^[Yy]$ ]]; then
    log_info "Installing music setup..."
    
    AUR_HELPER=""
    if command -v yay &> /dev/null; then
        AUR_HELPER="yay"
    elif command -v paru &> /dev/null; then
        AUR_HELPER="paru"
    fi

    PACKAGES="mpd rmpc mpd-mpris"
    
    if [ -n "$AUR_HELPER" ]; then
        log_info "Using $AUR_HELPER to install packages..."
        $AUR_HELPER -S --needed $PACKAGES
    else
        log_warning "No AUR helper (yay/paru) found. Trying pacman (some packages might be missing)..."
        sudo pacman -S --needed $PACKAGES
    fi

    log_info "Enabling services..."
    systemctl --user enable --now mpd || log_warning "Failed to enable mpd"
    systemctl --user enable --now mpd-mpris || log_warning "Failed to enable mpd-mpris"
    
    log_success "Music setup installed and enabled."
else
    log_info "Skipping music setup."
fi

# 6. Check for omarchy-theme-install and suggest running it if needed
if command -v omarchy-theme-install &> /dev/null; then
    echo -e "\nIt seems you have 'omarchy-theme-install'. Would you like to apply this theme now? [y/N]"
    read -r apply_theme
    if [[ "$apply_theme" =~ ^[Yy]$ ]]; then
        log_info "Applying theme..."
        omarchy-theme-install "$SOURCE_DIR"
    fi
else
    echo -e "\n${YELLOW}Note:${NC} 'omarchy-theme-install' command not found."
    echo "The theme files have been copied to $INSTALL_DIR."
    echo "You may need to manually configure your applications to point to these files"
    echo "or install the omarchy tools."
fi

echo -e "\n${GREEN}Installation complete!${NC}"
if [ -d "$BACKUP_DIR" ]; then
    echo "Backups were saved to: $BACKUP_DIR"
fi
