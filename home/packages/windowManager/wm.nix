{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    clipse
  ];
  imports = [
    ./sway.nix
    ./hyprland.nix
  ];
}
