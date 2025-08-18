{
  pkgs,
  ...
}:

{

  # Magic fuse filesystem basically replaces calls to "/bin/<program>" with "/usr/bin/env <program>"
  services.envfs.enable = true;
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    ripgrep
    unzip
    lm_sensors
    jq
    ncdu
    compsize
    # Killall etc.
    psmisc
    file

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

  programs = {
    zsh.enable = true;

    nix-ld.enable = true;

    nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
  };
}
