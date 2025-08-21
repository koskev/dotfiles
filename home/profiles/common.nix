{
  pkgs,
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
    ../packages/misc.nix
    ../packages/zsh.nix
    ../packages/lsp.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    lazygit = {
      enable = true;
      settings = {
        promptToReturnFromSubprocess = false;
        git.overrideGpg = true;
      };
    };
  };
}
