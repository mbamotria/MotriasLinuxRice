
-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
  hl.exec_cmd("mpvpaper -o \"no-audio --loop-playlist shuffle\" HDMI-A-3 ~/Pictures/Wallpaper/tartaglia.mkv")
  hl.exec_cmd("vicinae server")  
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("kdeconnect-indicator")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("zathura ~/Documents/Books/Bram_Stoker/Dracula.pdf")
end)
