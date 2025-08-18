{
  pkgs,
  ...
}:

{

  imports = [
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    teams-for-linux
    gotestsum
  ];
}
