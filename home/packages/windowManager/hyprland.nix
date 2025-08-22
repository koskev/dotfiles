{
  ...

}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      "$mod" = "SUPER";

      exec-once = [
        "waybar"
        "swayautonames"
        "rufaco"
      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        layout = "dwindle";
      };

      # https://wiki.hypr.land/Configuring/Binds/
      bindl = [
        '', XF86AudioRaiseVolume, exec, pactl set-sink-volume "@DEFAULT_SINK@" "+5%"''
        '', XF86AudioLowerVolume, exec, pactl set-sink-volume "@DEFAULT_SINK@" "-5%"''
        ", XF86AudioPlay, exec, mpc toggle"
        ", XF86AudioNext, exec, mpc next"
        ", XF86AudioPrev, exec, mpc prev"
      ];

      bind = [
        #   "$mod, T, exec, /tmp/test.py --enable-notify true"
        "$mod, Return, exec, alacritty"
        "$mod, w, togglegroup"
        "$mod, f, fullscreen"
        "$mod, d, exec, rofi -show drun"
        "$mod, M, exit,"
        "$mod SHIFT, Q, killactive,"
        "$mod SHIFT, y, movecurrentworkspacetomonitor, l"
        "$mod SHIFT, x, movecurrentworkspacetomonitor, r"
        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

      ];
    };
  };

}
