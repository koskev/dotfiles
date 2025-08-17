{
  pkgs,
  ...
}:

{
  programs.gnupg.agent.enable = true;

  environment.systemPackages = with pkgs; [
    sway
    rofi
    waybar
    slurp
    grim
    wl-clipboard-rs
    mate.caja
    syncthing

    alacritty
    xterm
    unzip
    tmux
    htop

    helvum
    pavucontrol

    lazygit
    gnupg

    keepassxc

    # Music
    mpd
    mpc
    cantata

    element-desktop
    thunderbird

  ];
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome_6
    siji
  ];

  programs.sway.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
