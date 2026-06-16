_: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    lib.mkIf (config.userSettings.desktopBar == "noctalia") {
      home.packages = [ pkgs.noctalia-shell ];
      xdg.configFile."noctalia/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.hostSettings.system.flake}/configs/noctalia/settings.json";
    };
}
