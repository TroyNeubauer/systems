{ writeText, writeShellScript, alacritty, firefox, rofi, pavucontrol, blueman, enforceDuo }: 
let
  enforceDuoScript = writeShellScript "enforce-duo" ''
    if [ -f /tmp/.computer_unblocked ]; then
      # Allowed: run the normal program
      echo allowed RUNNING: "$1"
      eval "$1"
    else
      # Blocked: run the fallback program
      echo BLOCKED RUNNING: "$2"
      eval "$2"
    fi
  '';
  launchRofiScript = writeShellScript "launch-rofi" "${rofi}/bin/rofi -modi drun,run -show drun";
  launchDuoFirefox = writeShellScript "launch-duo-firefox" "${firefox}/bin/firefox --new-tab https://duolingo.com --new-tab http://127.0.0.1:4550/";
in writeText "i3_config" ''

# Please see https://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

font pango:monospace 8
exec --no-startup-id dex --autostart --environment i3

# Launch allowed apps for compluting duolingo (firefox + sound + bluetooth)
${if enforceDuo then ''
  exec --no-startup-id ${launchDuoFirefox}
  exec --no-startup-id ${pavucontrol}/bin/pavucontrol
  exec --no-startup-id ${blueman}/bin/blueman-manager
'' else ""}

set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# Enforce Duo complete to open terminal, do nothing when incomplete
${if enforceDuo then
  "bindsym $mod+Return exec ${enforceDuoScript} ${alacritty}/bin/alacritty ${launchDuoFirefox}"
else
  "bindsym $mod+Return exec ${alacritty}/bin/alacritty"}

bindsym $mod+Shift+j kill

# Enforce Duo complete for dmenu, open duo website when incomplete
${if enforceDuo then
  "bindsym $mod+d exec ${enforceDuoScript} ${launchRofiScript} ${launchDuoFirefox}"
else
  "bindsym $mod+d exec \"rofi -modi drun,run -show drun\""}


# change focus
bindsym $mod+h focus left
bindsym $mod+t focus down
bindsym $mod+n focus up
bindsym $mod+s focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+t move down
bindsym $mod+Shift+n move up
bindsym $mod+Shift+s move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+x exec "i3-msg exit"

# resize window (you can also use the mouse for that)
mode "resize" {
    # same bindings, but for the arrow keys
    bindsym Left resize shrink width 4 px or 4 ppt
    bindsym Down resize grow height 4 px or 4 ppt
    bindsym Up resize shrink height 4 px or 4 ppt
    bindsym Right resize grow width 4 px or 4 ppt

    bindsym h resize shrink width 4 px or 4 ppt
    bindsym j resize grow height 4 px or 4 ppt
    bindsym k resize shrink height 4 px or 4 ppt
    bindsym s resize grow width 4 px or 4 ppt

    # back to normal: Enter or Escape or $mod+r
    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
    status_command i3status
}
''
