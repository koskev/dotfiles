{
  config,
  lib,
  ...
}:
{
  home.file = {
    "${config.xdg.configHome}/swayautonames/config.json".text = lib.generators.toJSON { } {
      "app_symbols" = {
        "firefox" = "";
        "zen" = "";
        "zen-twilight" = "";
        "Alacritty" = "";
        "element" = "";
        "cantata" = "";
        "org.keepassxc.KeePassXC" = "";
        "lutris" = "";
        "caja" = "";
        "thunderbird" = "";
        "mpv" = "";
        "Steam" = "";
        "steamwebhelper" = "";
        "org.openscad.openscad" = "";

        "teams-for-linux" = "󰊻";
      };
    };
  };
}
