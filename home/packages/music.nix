{ pkgs, ... }:
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
}
