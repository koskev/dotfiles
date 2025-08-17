{
  pkgs,
  settings,
  config,
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
    zsh = {
      enable = true;

      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        size = 10000000;
      };
      initContent = ''
        for file in ''${ZDOTDIR}/*.zsh; do
            source "$file"
        done

        eval "$(direnv hook zsh)"

        # For non-nix browser due to read only profiles.ini
        export MOZ_LEGACY_PROFILES=1

        # Use the old histfile for now
        export HISTFILE=/home/kevin/.zsh_history

        # Not compatible with append only histfile
        unsetopt HIST_FCNTL_LOCK
      '';
      shellAliases =
        let
          flake_dir = builtins.getEnv "FLAKE_PATH";
        in
        {
          hm = "home-manager --impure --flake ${flake_dir}#${settings.profile} -b backup";
        };
    };
  };
}
