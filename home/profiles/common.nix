{
  pkgs,
  lib,
  settings,
  ...
}:

{
  home = {
    username = "${settings.username}";
    homeDirectory = "${settings.homedir}";
    inherit (settings) stateVersion;
  };

  imports = [
    ../packages/base.nix
    ../packages/kubernetes.nix
    ../packages/shell/common.nix
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
        git.overrideGpg = true;
      };
    };
  };
}
