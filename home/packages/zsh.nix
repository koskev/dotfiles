{
  settings,
  lib,
  config,
  ...
}:
{
  programs.zsh = {

    enable = true;
    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/svn"
        "qwelyt/endless-dog"
        "superbrothers/zsh-kubectl-prompt kind:defer"

        "zsh-users/zsh-autosuggestions kind:defer"
        "junegunn/fzf path:shell kind:defer"
        "zsh-users/zsh-completions kind:defer"

        # Syntax highlighting bundle. Should be the last plugin
        "zsh-users/zsh-syntax-highlighting kind:defer"
      ];
    };

    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      size = 10000000;
    };
    # XXX: Move compinit to the beginning, since it slows down sourcing antidote by about 500ms (no idea why)
    completionInit = "";
    initContent = lib.mkMerge [
      (lib.mkOrder 500 "autoload -U compinit && compinit")
      # Before alias
      (lib.mkOrder 1000 ''
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
        # Kubernetes cluster on side
        RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
      '')
    ];
    shellAliases =
      let
        flake_dir = builtins.getEnv "FLAKE_PATH";
      in
      {
        hm = "home-manager --impure --flake ${flake_dir} -b backup";
        k = "kubectl";
        ls = "lsd";
        dmesgj = "journalctl --dmesg -o short-monotonic --no-hostname --no-pager";
        sway = "WRL_RENDERER=vulkan WLR_SCENE_DISABLE_DIRECT_SCANOUT=1 WLR_RENDER_NO_EXPLICIT_SYNC=1 sway > /tmp/sway.log 2>&";
        chezmoi-cd = "$(chezmoi source-path)";
        # Make aliases work with sudo
        sudo = "sudo ";
      }
      // lib.optionalAttrs settings.system.nixos {
        nr = "nixos-rebuild --flake ${flake_dir}";
      };

    localVariables = {
    };
    envExtra = ''
      EDITOR=nvim
      RADV_PERFTEST=gpl
      # for docker buildx
      DOCKER_BUILD_KIT=1
      DOCKER_CLI_EXPERIMENTAL=enabled
      # For weird work shell (no problem on nix due to envfs)
      SHELL=/bin/zsh
    '';
  };

}
