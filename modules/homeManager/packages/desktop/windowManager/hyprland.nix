_: {
  flake.modules.homeManager.desktop =
    {
      lib,
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
            # No anime wallpaper for "professional". Force it otherwise to have a balance
            force_default_wallpaper = if config.userSettings.professional then 0 else 2;
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
            "opacity 1.0 override 1.0, match:class ^(zen-twilight|zen-beta)$"

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
            "$mod, asciicircum, togglespecialworkspace, scratchpad" # asciicircum == ^
            "$mod SHIFT, asciicircum, movetoworkspace, special:scratchpad" # asciicircum == ^
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            "$mod SHIFT, left, movewindow, l"
            "$mod SHIFT, right, movewindow, r"
            "$mod SHIFT, up, movewindow, u"
            "$mod SHIFT, down, movewindow, d"
            "$mod, e, exec, ${./toggle_group.py} --enable-notify true"

            "$mod, 0, workspace, 10"
            "$mod SHIFT, 0, movetoworkspacesilent, 10"
          ]
          ++ builtins.concatMap (val: [
            "$mod, ${toString val}, workspace, ${toString val}"
            "$mod SHIFT, ${toString val}, movetoworkspacesilent, ${toString val}"
          ]) (lib.lists.range 1 9)
          ++ builtins.concatMap (val: [
            "$mod, F${toString val}, workspace, ${toString (10 + val)}"
            "$mod SHIFT, F${toString val}, movetoworkspacesilent, ${toString (10 + val)}"
          ]) (lib.lists.range 1 12);
        };
      }
      // lib.optionalAttrs config.hostSettings.system.nonNixos {
        package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);
      };

    };
}
