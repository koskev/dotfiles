{ aliases }:
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
        # For my usual keybinds
        "ohmyzsh/ohmyzsh path:lib"
        #"ohmyzsh/ohmyzsh path:plugins/git"
        #"ohmyzsh/ohmyzsh path:plugins/svn"
        #"qwelyt/endless-dog"
        #"superbrothers/zsh-kubectl-prompt kind:defer"

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
        export HISTFILE=${settings.homedir}/.zsh_history

        # Not compatible with append only histfile
        unsetopt HIST_FCNTL_LOCK
        # Kubernetes cluster on side
        #RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

        export PATH=$PATH:~/bin:~/.local/bin:~/.cargo/bin

        export MOZ_ENABLE_WAYLAND=1

        export WLR_DRM_NO_ATOMIC=1
        export WLR_NO_HARDWARE_CURSORS=1
        #export QT_QPA_PLATFORM=wayland
        # fix java stuff in wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh


        if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        	${settings.userSettings.defaultDesktop}
        fi

      '')
    ];
    shellAliases = aliases;

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
  home.file.".zshrc" = {
    text = ''
      #export XDG_CONFIG_HOME=''${$XDG_CONFIG_HOME:=''${HOME}/.config}
      export XDG_CONFIG_HOME=''${HOME}/.config
      export ZDOTDIR=''${ZDOTDIR:=''${XDG_CONFIG_HOME}/zsh}
      source $ZDOTDIR/.zshrc
    '';
  };

}
