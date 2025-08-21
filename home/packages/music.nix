{
  pkgs,
  config,
  ...
}:
{

  home.packages = with pkgs; [

    # Music
    mpd
    mpc
    cantata
  ];

  xdg.configFile.cantata = {
    source = ../../configs/cantata;
  };
  services = {
    mpd = {
      enable = true;
      playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
      dataDir = "${config.home.homeDirectory}/.config/mpd";
    };
  };
}
