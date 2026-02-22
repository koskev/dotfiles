_: {
  flake.modules.homeManager.desktop =
    {
      config,
      lib,
      ...
    }:
    {
      wayland.windowManager.sway = {
        enable = true;
        extraConfig = builtins.readFile ./sway.conf;
        config = null;
      }
      // lib.optionalAttrs config.hostSettings.system.nonNixos {
        # Don't use the package on non nix os for now
        package = null;
      };

    };
}
