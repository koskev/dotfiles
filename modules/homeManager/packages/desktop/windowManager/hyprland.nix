_: {
  flake.modules.homeManager.desktop =
    {
      lib,
      settings,
      config,
      pkgs,
      ...

    }:
    {
      home.packages = with pkgs; [
        hypridle
      ];
      programs.hyprlock = {
        enable = true;
      };
      xdg.configFile = {
        "clipse/config.json".text = lib.generators.toJSON { } {
          imageDisplay = {
            type = "kitty";
          };
        };
        "hypr/hypridle.conf".text = lib.hm.generators.toHyprconf {
          attrs = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
              before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
              after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
            };
            listener = [
              {
                timeout = 150;
                on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
                on-resume = "brightnessctl -r"; # monitor backlight restore.
              }
              {
                timeout = 300;
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 600;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
              }
            ];
          };
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {

          "$mod" = "SUPER";

          exec-once = [
            "waybar"
            "swayautonames --window-manager hyprland"
            "rufaco"
            "clipse -listen"
            "push_to_talk_rs"
            "hypridle"
          ];

          input = {
            kb_layout = "de";
            kb_variant = "nodeadkeys";
            kb_options = "caps:none";
          };

          general = {
            gaps_in = 0;
            gaps_out = 0;
            layout = "dwindle";
          };

          decoration = {
            shadow = {
              enabled = false;
            };
          };

          misc = {
            # Only for fullscreen
            vrr = 2;
            enable_anr_dialog = false;
          };

          binds = {
            # Switch back and forth between the current and last with e.g. mod + 1
            workspace_back_and_forth = true;
            # Move focus like sway
            movefocus_cycles_groupfirst = true;
          };

          windowrule = [
            "opacity 1.0 override 0.95, match:class .*"
            # XXX: Negative lookahead does not seem to work :/
            "opacity 1.0 override 1.0, match:class ^(zen-twilight)$"

            # Clipse window
            "float on, size 622 652, match:class (clipse)" # set the size of the window as necessary

            # Keep the focus on rofi to not lose focus on mouse movement
            "stay_focused on, match:class (Rofi)$"

            # Workspace selector: https://wiki.hypr.land/Configuring/Workspace-Rules/#workspace-selectors
            "opacity 0.7, match:workspace s[true]"
          ];

          workspace = [
            "special:scratchpad, on-created-empty:alacritty"
            "s[true], gapsout:100"
            "s[true], gapsin:10"
          ];

          bindm = [
            # mouse movements
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];

          # https://wiki.hypr.land/Configuring/Binds/
          bindl = [
            '', XF86AudioRaiseVolume, exec, pactl set-sink-volume "@DEFAULT_SINK@" "+5%"''
            '', XF86AudioLowerVolume, exec, pactl set-sink-volume "@DEFAULT_SINK@" "-5%"''
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          bind = [
            ''$mod SHIFT, s, exec, slurp | grim -g - "/tmp/screenshot.png"''
            "$mod, escape, exec, hyprlock"
            "$mod, v, exec, kitty --class clipse -e clipse"
            #   "$mod, T, exec, /tmp/test.py --enable-notify true"
            "$mod, Return, exec, alacritty"
            "$mod, w, togglegroup"
            "$mod, f, fullscreen,1"
            "$mod, d, exec, rofi -show drun -x11" # Use X11 for now to close on outside click
            "$mod, M, exit,"
            "$mod SHIFT, space, togglefloating,"
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
            "$mod, F1, workspace, 11"
            "$mod, F2, workspace, 12"
            "$mod, F3, workspace, 13"
            "$mod, F4, workspace, 14"
            "$mod, F5, workspace, 15"
            "$mod, F6, workspace, 16"
            "$mod, F7, workspace, 17"
            "$mod, asciicircum, togglespecialworkspace, scratchpad" # asciicircum == ^
            "$mod SHIFT, asciicircum, movetoworkspace, special:scratchpad" # asciicircum == ^
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
            "$mod SHIFT, F1, movetoworkspacesilent, 11"
            "$mod SHIFT, F2, movetoworkspacesilent, 12"
            "$mod SHIFT, F3, movetoworkspacesilent, 13"
            "$mod SHIFT, F4, movetoworkspacesilent, 14"
            "$mod SHIFT, F5, movetoworkspacesilent, 15"
            "$mod SHIFT, F6, movetoworkspacesilent, 16"
            "$mod SHIFT, F7, movetoworkspacesilent, 17"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            "$mod SHIFT, left, movewindow, l"
            "$mod SHIFT, right, movewindow, r"
            "$mod SHIFT, up, movewindow, u"
            "$mod SHIFT, down, movewindow, d"
            "$mod, e, exec, ${./toggle_group.py} --enable-notify true"

          ];
        };
      }
      // lib.optionalAttrs (!settings.system.nixos) {
        package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);
      };

    };
}
