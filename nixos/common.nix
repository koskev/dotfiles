{
  pkgs,
  ...
}:

{
  imports = [
    ./packages/network/wireguard.nix
  ];

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
    lm_sensors
    jq
    # Killall etc.
    psmisc
    file
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;

    nix-ld.enable = true;

    nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
  };
}
