{ pkgs, ... }:
{
  home.packages = with pkgs; [
    thunderbird
  ];
  services.etesync-dav = {
    enable = true;
    serverUrl = "https://etesync.kokev.de";
  };
}
