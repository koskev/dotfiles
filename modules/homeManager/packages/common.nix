{ inputs, ... }:
{
  flake.modules.homeManager.common =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      nixpkgs.overlays = [
        inputs.nur.overlays.default
        inputs.nixgl.overlay
      ];
      home = {
        stateVersion = "25.11";
        username = lib.mkDefault config.userSettings.userName;
        homeDirectory = lib.mkDefault config.userSettings.home;
      };
      # Due to joplin an feishin
      nixpkgs.config.permittedInsecurePackages = [
        "electron-36.9.5"
      ];

      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];

      programs.nix-index-database.comma.enable = true;
      nix = {
        package = lib.mkDefault pkgs.nix;
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      programs = {
        nh = {
          enable = true;
          flake = config.userSettings.flakeLocation or null;
        };
        home-manager.enable = true;
        lazygit = {
          enable = true;
          settings = {
            promptToReturnFromSubprocess = false;
            git = {
              overrideGpg = true;
              pagers = [
                {
                  useExternalDiffGitConfig = true;
                }
              ];
            };
          };
        };
        difftastic = {
          enable = true;
          package = inputs.difftastic.defaultPackage.${pkgs.stdenv.hostPlatform.system};
          git = {
            enable = true;
          };
        };
        jujutsu = {
          enable = true;
          settings = {
            ui = {
              diff-formatter = [
                "difft"
                "--color=always"
                "$left"
                "$right"
              ];
            };
          };
        };
      };
    };
}
