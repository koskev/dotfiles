{
  pkgs,
  config,
  ...
}:
{

  home.packages = with pkgs; [

    # Music
    mpc
    cantata
    playerctl
  ];
  # RS version not in repo :/
  services.mpdris2.enable = true;

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
