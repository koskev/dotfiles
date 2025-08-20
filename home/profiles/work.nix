{
  pkgs,
  config,
  nixgl,
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

  nixGL = {
    vulkan.enable = true;
    inherit (nixgl) packages;
  };
}
