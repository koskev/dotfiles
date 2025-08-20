{
  pkgs,
  config,
  ...
}:

{

  imports = [
    ./desktop.nix
    ../packages/kanshi_work.nix
  ];

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap teams-for-linux)
    gotestsum
  ];
}
