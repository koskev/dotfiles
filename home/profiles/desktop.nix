{
  inputs,
  pkgs,
  ...
}:
{

  gtk.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 0;
  };
  programs.alacritty = {
    enable = true;
    settings = {
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
  };
  imports = [
    ../packages/browser.nix
  ];
}
