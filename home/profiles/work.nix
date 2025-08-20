{
  pkgs,
  config,
  ...
}:

{

  imports = [
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap teams-for-linux)
    gotestsum
  ];
}
