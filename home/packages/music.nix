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
  services.mpd-mpris.enable = true;

  xdg.configFile.cantata = {
    source = ../../configs/cantata;
  };
  services = {
    mpd = {
      enable = true;
      playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
      dataDir = "${config.home.homeDirectory}/.config/mpd";
      extraConfig = ''
        # Set output explicitly, otherwise seeking and playing the next song won't work
        audio_output {
          type "pipewire"
          name "Local Music Player Daemon"
        }
      '';
    };
  };
}
