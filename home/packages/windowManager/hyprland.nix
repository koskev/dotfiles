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
      };

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
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        #"$mod, h, hy3:movefocus, l"
        #"$mod SHIFT, h, hy3:movewindow, l"
        #"$mod  l, hy3:movefocus, r"
        #"$mod SHIFT, l, hy3:movewindow, r"
        #"$mod  k, hy3:movefocus, u"
        #"$mod SHIFT, k, hy3:movewindow, u"
        #"$mod  j, hy3:movefocus, d"
        #"$mod SHIFT, j, hy3:movewindow, d"
        "$mod,  v, hy3:makegroup, v, force_empheral"
        "$mod,  b, hy3:makegroup, h, force_empheral"
        "$mod,  t, hy3:makegroup, tab, force_empheral"
        #"$mod CTRL, k, hy3:changefocus, raise"
        #"$mod CTRL, j, hy3:changefocus, lower"
        #"$mod SHIFT, 1, hy3:movetoworkspace, 1"
        #"$mod SHIFT, 2, hy3:movetoworkspace, 2"
        #"$mod SHIFT, 3, hy3:movetoworkspace, 3"
        #"$mod SHIFT, 4, hy3:movetoworkspace, 4"
        #"$mod SHIFT, 5, hy3:movetoworkspace, 5"
        #"$mod SHIFT, 6, hy3:movetoworkspace, 6"
        #"$mod SHIFT, 7, hy3:movetoworkspace, 7"
        #"$mod SHIFT, 8, hy3:movetoworkspace, 8"
        #"$mod SHIFT, 9, hy3:movetoworkspace, 9"
        #"$mod SHIFT, 0, hy3:movetoworkspace, 10"

      ];
    };
  };

}
