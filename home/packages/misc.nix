{ pkgs, ... }:
{
  home.packages = with pkgs; [
    siril
    feishin
    xsane
    statix
    tokei
    borgbackup
    sops
  ];
}
