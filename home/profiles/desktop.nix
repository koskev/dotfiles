{
  inputs,
  pkgs,
  ...
}:
{

  gtk.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 0;
  };
  imports = [
    ../packages/browser.nix
    inputs.zen-browser.homeModules.twilight
  ];
}
