{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    dejavu_fonts # Default font
    nerd-fonts.dejavu-sans-mono # For nerd-font symbols as fallback
    gyre-fonts # For waybar. Small and nice font
  ];
  fonts.fontconfig = {
    enable = true;
  };
}
