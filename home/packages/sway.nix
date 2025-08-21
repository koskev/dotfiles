{
  settings,
  lib,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = builtins.readFile ./sway.conf;
    config = null;
  }
  // lib.optionalAttrs (!settings.system.nixos) {
    # Don't use the package on non nix os for now
    package = null;
  };

}
