{
  settings,
  config,
  ...
}:
{
  programs.zsh = {
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
        k = "kubectl";
        ls = "lsd";
        dmesgj = "journalctl --dmesg -o short-monotonic --no-hostname --no-pager";
        sway = "WRL_RENDERER=vulkan WLR_SCENE_DISABLE_DIRECT_SCANOUT=1 WLR_RENDER_NO_EXPLICIT_SYNC=1 sway > /tmp/sway.log 2>&";
      };
  };

}
