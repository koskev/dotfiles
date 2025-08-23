{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard
    swaynotificationcenter
    waybar
    slurp
    grim
    clipse
    # For clipse image preview
    kitty
  ];
  imports = [
    ./sway.nix
    ./hyprland.nix
  ];
}
