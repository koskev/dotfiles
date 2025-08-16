{
  pkgs,
  settings,
  lib,
  config,
  ...
}:

{
  home.username = "${settings.username}";
  home.homeDirectory = "${settings.homedir}";
  home.stateVersion = "24.05";

  imports = [
    ./chezmoi.nix

    packages/base.nix
    packages/kubernetes.nix
    packages/browser.nix
    packages/misc.nix
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
    zsh = {
      enable = true;

      dotDir = "${config.xdg.configHome}/zsh";
      initContent =
        let
          flake_dir = builtins.getEnv "FLAKE_PATH";
        in
        lib.mkForce ''
          autoload -Uz compinit
          compinit
          for file in ''${ZDOTDIR}/*.zsh; do
              source "$file"
          done

          [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
          eval "$(direnv hook zsh)"

          alias hm="home-manager --impure --flake ${flake_dir} -b backup"
          # For non-nix browser due to read only profiles.ini
          export MOZ_LEGACY_PROFILES=1
        '';
    };
  };
}
