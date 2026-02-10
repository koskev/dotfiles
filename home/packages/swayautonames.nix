{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.swayautonames.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];
  home.file = {
    "${config.xdg.configHome}/swayautonames/config.json".text = lib.generators.toJSON { } {
      "app_symbols" = {
        "firefox" = "";
        "zen" = "";
        "zen-twilight" = "";

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
}
