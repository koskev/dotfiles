{
  pkgs,
  settings,
  ...
}:

{
  home.username = "${settings.username}";
  home.homeDirectory = "${settings.homedir}";
  home.stateVersion = "24.05";

  imports = [
    ../packages/chezmoi.nix

    ../packages/base.nix
    ../packages/kubernetes.nix
    ../packages/misc.nix
    ../packages/zsh.nix
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
  };
}
