{ inputs, ... }: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      config = lib.mkIf (config.userSettings.desktopBar == "noctalia5") {
        home.packages = [ pkgs.ddcutil ];
        programs.noctalia = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings = {
            # This may also be a string or path to a .toml file.
            theme = {
              builtin = "Rosé Pine";
            };
            bar = {
              default = {
                start = [
                  "clock"
                  "active_window"
                  "ram"
                  "sysmon"
                ];
                end = [
                  "media"
                  "tray"
                  "notifications"
                  "clipboard"
                  "network"
                  "bluetooth"
                  "volume"
                  "brightness"
                  "battery"
                  "session"
                ];

                center = [ "taskbar" ];
                margin_edge = 0;
                margin_ends = 0;
              };
            };
            shell = {
              panel.open_near_click_control_center = true;
              screen_time_enabled = true;
            };
            widget = {
              active_window.capsule = true;
              taskbar.group_by_workspace = true;
              media.capsule = true;
              ram.show_label = false;
              sysmon.show_label = false;
            };
            location.auto_locate = true;
            wallpaper.enabled = false;
          };
        };
      };
    };
}
