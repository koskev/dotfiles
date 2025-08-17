{
  pkgs,
  ...
}:

{
  programs = {
    gnupg.agent.enable = true;
    sway.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sway
    rofi
    waybar
    slurp
    grim
    wl-clipboard-rs
    mate.caja
    syncthing
    wdisplays
    xorg.xrandr
    libnotify
    dunst

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
    meld
  ];
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome_6
    siji
  ];

  xdg.portal.wlr.enable = true;
}
