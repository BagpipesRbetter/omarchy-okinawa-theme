# Okinawa - The beach episode

imageine that beach trip to okinawa in your favorite anime, thats this theme. oceanic blues with a custom theme for rmpc the BEST mpd client

# Installation

## Easy Install (Recommended)
Run the included script to install the theme and optional extras (RMPC, Waybar):
```bash
./install.sh
```

## Via Omarchy CLI
```bash
omarchy-theme-install https://github.com/BagpipesRbetter/omarchy-okinawa-theme
```

# Extras

The installation script (`./install.sh`) can automatically install these extras for you. It can also install and configure the **Music Setup** (`mpd`, `rmpc`, `mpd-mpris`).

If you prefer to do it manually:

## RMPC (MPD Client)
To use the custom RMPC theme:
1. Copy the `custom/rmpc` folder to your config directory:
   ```bash
   cp -r ~/.config/omarchy/themes/okinawa/custom/rmpc ~/.config/
   ```
2. Ensure the script is executable:
   ```bash
   chmod +x ~/.config/rmpc/Scripts/songchange.sh
   ```

## Custom Waybar Layout
To use the custom Waybar layout instead of the default Omarchy one:
1. Backup your existing Waybar config.
2. Copy the configs:
   ```bash
   cp -r ~/.config/omarchy/themes/okinawa/custom/waybar/* ~/.config/waybar/
   ```
