{
  settings,
  ...
}:
{

  xdg.configFile."waybar" = {
    source = ../../configs/waybar/themes/${settings.userSettings.waybarTheme};
    recursive = true;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        # "layer"= "top" # Waybar at top layer
        # "position"= "bottom" # Waybar position (top|bottom|left|right)
        height = 24; # Waybar height (to be removed for auto height)
        # "width"= 1280 # Waybar width
        spacing = 0; # Gaps between modules (4px)
        # Choose the order of the modules
        modules-left = [
          "hyprland/workspaces"
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ ];
        modules-right = builtins.filter (x: x != null) [
          "custom/media"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "disk#root"
          "disk#storage"
          "memory"
          "cpu"
          (if settings.system.sensors.cpu or null != null then "temperature#cpu" else null)
          (if settings.system.sensors.water or null != null then "temperature#water" else null)
          "backlight"
          "battery"
          "clock"
          "custom/notification"
          "tray"
        ];
        "sway/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
        };
        "disk#root" = {
          "interval" = 30;
          "format" = "{path}: {free}";
          "path" = "/";
        };
        "disk#storage" = {
          "interval" = 30;
          "format" = "storage: {free}";
          "path" = "/mnt/nvme_storage";
        };
        "custom/media" = {
          "format" = "{icon}{text}";
          "return-type" = "json";
          "format-icons" = {
            "Paused" = " ";
            "Playing" = " ";
          };
          "max-length" = 70;
          "exec" =
            let
              format = builtins.toJSON {
                text = "{{playerName}}: {{artist}} - {{markup_escape(title)}}";
                tooltip = "{{playerName}} : {{markup_escape(title)}}";
                alt = "{{status}}";
                class = "{{status}}";
              };
            in
            "playerctl -a metadata --format '${format}' -F";
          "on-click" = "playerctl play-pause";
        };
        "mpd" = {
          "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {title}";
          "format-disconnected" = "Disconnected";
          "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped";
          "unknown-tag" = "N/A";
          "interval" = 2;
          "consume-icons" = {
            "on" = " ";
          };
          "random-icons" = {
            "off" = "<span color=\"#f53c3c\"></span> ";
            "on" = " ";
          };
          "repeat-icons" = {
            "on" = " ";
          };
          "single-icons" = {
            "on" = "1 ";
          };
          "state-icons" = {
            "playing" = "";
            "paused" = "";
          };
          "tooltip-format" = "MPD (connected)";
          "tooltip-format-disconnected" = "MPD (disconnected)";
          "max-len" = 20;
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "tray" = {
          # "icon-size"= 21;
          "spacing" = 10;
        };
        "clock" = {
          # "timezone"= "America/New_York";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
          "calendar" = {
            "format" = {
              "today" = "<span color='#ffffff'><b><u>{}</u></b></span>";
            };
          };
        };
        "cpu" = {
          "format" = "{usage}% ";
          "tooltip" = false;
        };
        "memory" = {
          "format" = " {}%";
        };
        "temperature#cpu" = {
          # "thermal-zone"= 2;
          "hwmon-path" = "${settings.system.sensors.cpu or ""}";
          "critical-threshold" = 80;
          # "format-critical"= "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
            ""
            ""
            ""
          ];
          "tooltip-format" = "CPU: {temperatureC}°C";
        };
        "temperature#water" = {
          # "thermal-zone"= 2;
          "hwmon-path" = "${settings.system.sensors.water or ""}";
          "critical-threshold" = 40;
          # "format-critical"= "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
            ""
            ""
            ""
          ];
          "tooltip-format" = "Water: {temperatureC}°C";
        };
        "backlight" = {
          # "device"= "acpi_video1";
          "format" = "{percent}% {icon}";
          "format-icons" = [
            ""
            ""
          ];
        };
        "battery" = {
          "states" = {
            # "good"= 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          # "format-good"= ""; # An empty format will hide the module
          # "format-full"= "";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "network" = {
          # "interface"= "wlp2*"; # (Optional) To force the use of this interface
          "format-ethernet" = "";
          "format-wifi" = "{icon}";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
        };
        "pulseaudio" = {
          # "scroll-step"= 1; # %; can be a float
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };
        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
          "mpris" = {
            "image-size" = 96;
            "image-radius" = 12;
            "blacklist" = [ "playerctld" ];
          };
        };
      };
    };
  };
}
