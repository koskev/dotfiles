{
  pkgs,
  ...
}:
{

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      "widgets" = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      "mpris" = {
        "image-size" = 96;
        "image-radius" = 12;
        "blacklist" = [ "playerctld" ];
        "autohide" = false;
      };
    };
  };

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
