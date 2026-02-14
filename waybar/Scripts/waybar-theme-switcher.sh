#!/usr/bin/env bash
# File: ~/.config/hypr/scripts/waybar-theme-switcher.sh

# Directory where your Waybar themes are stored
WAYBAR_DIR="$HOME/.config/waybar"

# Available themes (based on your folder structure)
THEMES=(
    "Default"
    "B&Waybar"
    "GlassWaybar"
    "PywalWaybar"
)

# Function to apply selected theme
apply_theme() {
    local theme="$1"

    # Kill current waybar instances
    pkill -TERM waybar 2>/dev/null
    sleep 0.5

    # Handle theme selection
    case "$theme" in
        "Default")
            # For default, use the main waybar directory files
            # They should already be in place, so we just restart
            notify-send "Waybar Theme" "Switched to Default theme" -i "waybar"
            ;;

        "B&Waybar")
            # Copy both config and style from B&Waybar
            cp "$WAYBAR_DIR/B&Waybar/config" "$WAYBAR_DIR/config"
            cp "$WAYBAR_DIR/B&Waybar/style.css" "$WAYBAR_DIR/style.css"
            notify-send "Waybar Theme" "Switched to B&Waybar theme" -i "waybar"
            ;;

        "GlassWaybar")
            # Copy both config and style from GlassWaybar
            cp "$WAYBAR_DIR/GlassWaybar/config" "$WAYBAR_DIR/config"
            cp "$WAYBAR_DIR/GlassWaybar/style.css" "$WAYBAR_DIR/style.css"
            # Also handle scripts if needed
            if [ -d "$WAYBAR_DIR/GlassWaybar/Scripts" ]; then
                cp -r "$WAYBAR_DIR/GlassWaybar/Scripts" "$WAYBAR_DIR/" 2>/dev/null
            fi
            notify-send "Waybar Theme" "Switched to GlassWaybar theme" -i "waybar"
            ;;

        "PywalWaybar")
            # Copy both config and style from PywalWaybar
            cp "$WAYBAR_DIR/PywalWaybar/config" "$WAYBAR_DIR/config"
            cp "$WAYBAR_DIR/PywalWaybar/style.css" "$WAYBAR_DIR/style.css"
            # Copy reset script if needed
            if [ -f "$WAYBAR_DIR/PywalWaybar/resetwaybar.sh" ]; then
                cp "$WAYBAR_DIR/PywalWaybar/resetwaybar.sh" "$WAYBAR_DIR/" 2>/dev/null
            fi
            notify-send "Waybar Theme" "Switched to PywalWaybar theme" -i "waybar"
            ;;
    esac

    # Make sure scripts are executable
    chmod +x "$WAYBAR_DIR"/*.sh 2>/dev/null
    chmod +x "$WAYBAR_DIR"/Scripts/*.sh 2>/dev/null

    # Small pause
    sleep 0.3

    # Restart waybar
    waybar >/tmp/waybar.log 2>&1 & disown
}

# Use rofi with your existing config
SELECTED_THEME=$(printf '%s\n' "${THEMES[@]}" | rofi -dmenu -p "Select Waybar Theme" -theme $HOME/.config/rofi/config.rasi)

# If no theme selected, exit
if [ -z "$SELECTED_THEME" ]; then
    # Make sure waybar is running
    if ! pgrep -x waybar > /dev/null; then
        waybar >/tmp/waybar.log 2>&1 & disown
    fi
    exit 0
fi

# Apply the selected theme
apply_theme "$SELECTED_THEME"
