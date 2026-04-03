{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.swayautonames.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      home.file = {
        "${config.xdg.configHome}/swayautonames/config.json".text = lib.generators.toJSON { } {
          "app_symbols" = {
            "firefox" = "";
            "zen" = "";
            "zen-twilight" = "";
            "zen-beta" = "";

            "Alacritty" = "";

            "element" = "";
            "Element" = "";

            "cantata" = "";
            "dog.unix.cantata.Cantata" = "";
            "org.keepassxc.KeePassXC" = "";

            "lutris" = "";
            "net.lutris.Lutris" = "";

            "caja" = "";
            "thunderbird" = "";
            "mpv" = "";

            "Steam" = "";
            "steamwebhelper" = "";
            "steam" = "";

            "org.openscad.openscad" = "";

            "teams-for-linux" = "󰊻";
          };
          "fullscreen_color" = "orange";
        };
      };
    };
}
