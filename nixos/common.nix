{
  pkgs,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    ripgrep
    unzip
    lm_sensors

    go
    cargo
    direnv
  ];
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome_6
    siji
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  programs.sway.enable = true;
}
