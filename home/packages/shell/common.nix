_: {

  imports =
    let
      aliases = {
        k = "kubectl";
        ls = "lsd";
        dmesgj = "journalctl --dmesg -o short-monotonic --no-hostname --no-pager";
        sway = "WRL_RENDERER=vulkan WLR_SCENE_DISABLE_DIRECT_SCANOUT=1 WLR_RENDER_NO_EXPLICIT_SYNC=1 sway > /tmp/sway.log 2>&1";
        # Make aliases work with sudo
        sudo = "sudo ";
        # Override library path to prevent weird linker error with enabled nixGL
        # XXX: Hopefully this won't be a problem anymore due to pure?
        #nh = ''LD_LIBRARY_PATH="" nh'';
        #home-manager = ''LD_LIBRARY_PATH="" home-manager'';
        nix-size = "nix path-info --recursive --size /run/current-system | sort -k2 -n | numfmt --field=2 --to=iec-i --suffix=B";
        nix-csize = "nix path-info --recursive --closure-size /run/current-system | sort -k2 -n | numfmt --field=2 --to=iec-i --suffix=B";
      };

      shellIntegrations = [
        "zoxide"
        "fzf"
        "starship"
      ];
    in
    [
      (import ./zsh.nix {
        inherit aliases;
        inherit shellIntegrations;
      })
      (import ./fish.nix {
        inherit aliases;
        inherit shellIntegrations;
      })
      ./starship.nix
    ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    EDITOR = "nvim";
  };

  programs = {
    zoxide = {
      enable = true;
    };
    fzf = {
      enable = true;
    };
  };
}
