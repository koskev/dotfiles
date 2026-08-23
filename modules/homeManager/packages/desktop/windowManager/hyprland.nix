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
      wayland.windowManager.hyprland =
        let
          mod = "SUPER";
          lua = lib.generators.mkLuaInline;
          bind = keys: dispatcher: {
            _args = [
              keys
              dispatcher
            ];
          };
          dsp = {
            exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
            fullscreen = mode: lua ''hl.dsp.window.fullscreen({ mode = "${mode}", action = "toggle" })'';
            workspace = workspace: lua ''hl.dsp.focus({ workspace = "${toString workspace}" })'';
            movetoworkspacesilent =
              ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}", follow = false })'';
            focus_dir = dir: lua ''hl.dsp.focus({direction="${dir}"})'';
            window = {
              close = lua "hl.dsp.window.close()";
              move_dir = dir: lua ''hl.dsp.window.move({direction="${dir}"})'';
            };
          };
          autostart = [
            "rufaco"
            "push_to_talk_rs"
            "hypridle"
          ]
          ++ lib.optionals (config.userSettings.desktopBar == "waybar") [
            "swayautonames --window-manager hyprland"
            "waybar"
            "clipse -listen"
          ]
          ++ lib.optionals (config.userSettings.desktopBar == "noctalia") [
            "noctalia-shell"
            "clipse -listen"
          ]
          ++ lib.optionals (config.userSettings.desktopBar == "noctalia5") [
            "noctalia"
          ];
        in
        {
          enable = true;
          configType = "lua";
          settings = {

            on = {
              _args = [
                "hyprland.start"
                (lua ''
                  function()
                     ${builtins.concatStringsSep "\n" (map (x: ''hl.exec_cmd("${x}")'') autostart)}
                  end
                '')
              ];
            };

            config = {
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
            };

            window_rule = [
              #"opacity 1.0 override 0.95, match:class .*"
              {
                match = {
                  class = ".*";
                };
                opacity = "1.0 override 0.95";
              }
              # XXX: Negative lookahead does not seem to work :/
              #"opacity 1.0 override 1.0, match:class ^(zen-twilight|zen-beta)$"
              {
                match = {
                  class = "^(zen-twilight|zen-beta)$";
                };
                opacity = "1.0 override 1.0";
              }

              # Clipse window
              #"float on, size 622 652, match:class (clipse)" # set the size of the window as necessary
              {
                match = {
                  class = "clipse";
                };
                float = true;
                size = "{622, 652}";
              }

              # Keep the focus on rofi to not lose focus on mouse movement
              #"stay_focused on, match:class (Rofi)$"
              {
                match = {
                  class = "Rofi";
                };
                stay_focused = true;
              }
              # Workspace selector: https://wiki.hypr.land/Configuring/Workspace-Rules/#workspace-selectors
              #"opacity 0.7, match:workspace s[true]"
              {
                match = {
                  workspace = "s[true]";
                };
                opacity = "0.7";
              }
            ];

            workspace_rule = [
              {
                workspace = "special:scratchpad";
                on_created_empty = "alacritty";
              }
              {
                workspace = "s[true]";
                gaps_out = 100;
                gaps_in = 10;
              }
            ];

            monitor = map (m: {
              inherit (m) output;
              inherit (m) mode;
              inherit (m) position;
              inherit (m) scale;
            }) config.hostSettings.system.monitors;

            bind = [
              (bind "${mod} + mouse:272" (lua "hl.dsp.window.drag()"))
              (bind "${mod} + mouse:273" (lua "hl.dsp.window.resize()"))
              (bind "${mod} + ALT + mouse:272" (lua "hl.dsp.window.resize()"))
              (bind "XF86AudioRaiseVolume" (dsp.exec "pactl set-sink-volume @DEFAULT_SINK@ +5%"))
              (bind "XF86AudioLowerVolume" (dsp.exec "pactl set-sink-volume @DEFAULT_SINK@ -5%"))
              (bind "XF86AudioPlay" (dsp.exec "playerctl play-pause"))
              (bind "XF86AudioNext" (dsp.exec "playerctl next"))
              (bind "XF86AudioPrev" (dsp.exec "playerctl previous"))
              (bind "${mod} + escape" (dsp.exec "hyprlock"))
              (bind "${mod} + Return" (dsp.exec "alacritty"))
              (bind "${mod} + w" (lua "hl.dsp.group.toggle()"))
              (bind "${mod} + f" (dsp.fullscreen "maximized"))
              (bind "${mod} + SHIFT + f" (dsp.fullscreen "fullscreen"))
              (bind "${mod} + M" (lua "hl.dsp.exit()"))
              (bind "${mod} + SHIFT + space" (lua "hl.dsp.window.float()"))
              (bind "${mod} + SHIFT + Q" dsp.window.close)
              (bind "${mod} + SHIFT + y" (lua ''hl.dsp.window.move({monitor = "l"})''))
              (bind "${mod} + SHIFT + x" (lua ''hl.dsp.window.move({monitor = "r"})''))
              (bind "${mod} + asciicircum" (lua ''hl.dsp.workspace.toggle_special("scratchpad")'')) # asciicircum == ^
              (bind "${mod} + SHIFT + asciicircum" (
                lua ''hl.dsp.window.move({ workspace = "special:scratchpad" })''
              )) # asciicircum == ^
              (bind "${mod} + left" (dsp.focus_dir "l"))
              (bind "${mod} + right" (dsp.focus_dir "r"))
              (bind "${mod} + up" (dsp.focus_dir "u"))
              (bind "${mod} + down" (dsp.focus_dir "d"))
              (bind "${mod} + SHIFT + left" (dsp.window.move_dir "l"))
              (bind "${mod} + SHIFT + right" (dsp.window.move_dir "r"))
              (bind "${mod} + SHIFT + up" (dsp.window.move_dir "u"))
              (bind "${mod} + SHIFT + down" (dsp.window.move_dir "d"))

              (bind "${mod} + 0" (dsp.workspace 10))
              (bind "${mod} + SHIFT + 0" (dsp.movetoworkspacesilent 10))
            ]
            ++ builtins.concatMap (val: [
              (bind "${mod} + ${toString val}" (dsp.workspace val))
              (bind "${mod} + SHIFT + ${toString val}" (dsp.movetoworkspacesilent val))
            ]) (lib.lists.range 1 9)
            ++ builtins.concatMap (val: [
              (bind "${mod} + F${toString val}" (dsp.workspace (10 + val)))
              (bind "${mod} + SHIFT + F${toString val}" (dsp.movetoworkspacesilent (10 + val)))
            ]) (lib.lists.range 1 12)
            ++ (
              if config.userSettings.desktopBar == "noctalia5" then
                [
                  (bind "${mod} + v" (dsp.exec "noctalia msg panel-open clipboard"))
                  (bind "${mod} + d" (dsp.exec "noctalia msg panel-open launcher"))
                  (bind "${mod} + SHIFT + s" (dsp.exec "noctalia msg screenshot-region"))
                ]
              else
                [
                  (bind "${mod} + v" (dsp.exec "kitty --class clipse -e clipse"))
                  (bind "${mod} + d" (dsp.exec "rofi -show drun -x11")) # Use X11 for now to close on outside click
                  (bind "${mod} + SHIFT + s" (dsp.exec ''slurp | grim -g - "/tmp/screenshot.png"''))
                ]
            );
          };
        }
        // lib.optionalAttrs config.hostSettings.system.nonNixos {
          package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);
        };

    };
}
