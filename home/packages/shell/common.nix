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
        nh = ''LD_LIBRARY_PATH="" nh'';
        home-manager = ''LD_LIBRARY_PATH="" home-manager'';
      };
    in
    [
      (import ./zsh.nix { inherit aliases; })
      (import ./fish.nix { inherit aliases; })
      ./starship.nix
    ];

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
