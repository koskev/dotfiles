{
  config,
  pkgs,
  settings,
  lib,
  ...
}:
{

  gtk.enable = true;
  xdg = {
    userDirs = {
      enable = true;
      music = "${config.home.homeDirectory}/Musik";
      pictures = "${config.home.homeDirectory}/Bilder";
    };
  };
  services = {
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = 53.0;
      longitude = 10.0;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    # XXX: 0 would set it to default but this breaks slurp 1.5 (master works). Setting it higher seems to only affect waybar widgets. By setting it to 24 the "desktop" and "waybar" cursors are the same size
    size = 24;
  };
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 1.0;
      colors = {
        bright = {
          black = "0x555753";
          blue = "0x729fcf";
          cyan = "0x34e2e2";
          green = "0x8ae234";
          magenta = "0xad7fa8";
          red = "0xef2929";
          white = "0xeeeeec";
          yellow = "0xfce94f";
        };
        normal = {
          black = "0x2e3436";
          blue = "0x3465a4";
          cyan = "0x06989a";
          green = "0x4e9a06";
          magenta = "0x75507b";
          red = "0xcc0000";
          white = "0xd3d7cf";
          yellow = "0xc4a000";
        };
        primary = {
          background = "0x000000";
          foreground = "0xd3d7cf";
        };
      };
      env = {
        TERM = "xterm-256color";
      };
      font = {
        size = 13;
      };
      keyboard.bindings = [
        {
          action = "SpawnNewInstance";
          key = "N";
          mods = "Control|Shift";
        }
      ];
      scrolling.history = 100000;
    };
  }
  // lib.optionalAttrs (!settings.system.nixos) {
    package = lib.mkForce (config.lib.nixGL.wrap pkgs.alacritty);
  };
  imports = [
    ../packages/fonts.nix
    ../packages/browser.nix
    ../packages/rofi.nix
    ../packages/windowManager/wm.nix
    ../packages/rufaco.nix
    ../packages/kanshi.nix
    ../packages/neovim.nix
    ../packages/music.nix
    ../packages/waybar.nix
    ../packages/swayautonames.nix
    ../packages/pushtotalk.nix
  ];
}
