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
      # Due to joplin an feishin
      nixpkgs.config.permittedInsecurePackages = [
        "electron-36.9.5"
      ];
      home = {
        stateVersion = "25.11";
        username = lib.mkDefault config.userSettings.userName;
        homeDirectory = lib.mkDefault config.userSettings.home;
      };

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
          inherit (config.hostSettings.system) flake;
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
          package = inputs.difftastic.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
