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
    alacritty
    xterm
    helvum
    pavucontrol
    unzip
    lazygit
    gnupg

    tmux
    keepassxc

    # Music
    mpd
    mpc
    cantata
  ];
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome_6
    siji
  ];

  programs.sway.enable = true;
}
