{ inputs, ... }: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      config = lib.mkIf (config.userSettings.desktopBar == "noctalia5") {
        programs.noctalia = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings = {
            # This may also be a string or path to a .toml file.
            theme = {
              mode = "dark";
              source = "builtin";
              builtin = "Catppuccin";
            };
          };
        };
      };
    };
}
