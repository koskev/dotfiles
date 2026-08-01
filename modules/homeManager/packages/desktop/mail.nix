_: {
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        thunderbird
      ];
      services.etesync-dav = {
        enable = false; # Disabled until the package is working again or I find the motivation to fix it myself
        serverUrl = "https://etesync.kokev.de";
      };
    };
}
