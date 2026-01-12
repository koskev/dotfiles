{
  pkgs,
  lib,
  settings,
  inputs,
  ...
}:

{
  home = {
    username = "${settings.username}";
    homeDirectory = "${settings.homedir}";
    inherit (settings) stateVersion;
  };
  # Due to joplin an feishin
  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5"
  ];

  imports = [
    ../packages/base.nix
    ../packages/kubernetes.nix
    ../packages/shell/common.nix
    ../packages/neovim.nix
    inputs.nix-index-database.homeModules.nix-index
    { programs.nix-index-database.comma.enable = true; }

  ];

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
      flake = settings.system.flake or null;
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
    mergiraf = {
      package = inputs.mergiraf.packages.${pkgs.stdenv.hostPlatform.system}.default;
      enable = true;
    };
  };
}
