_: {
  flake.modules.nixos.common =
    {
      pkgs,
      config,
      ...
    }:
    {
      networking.hostName = config.hostSettings.hostName;

      # Due to joplin an feishin
      nixpkgs.config.permittedInsecurePackages = [
        "electron-36.9.5"
      ];

      # Magic fuse filesystem basically replaces calls to "/bin/<program>" with "/usr/bin/env <program>"
      services = {
        envfs.enable = true;
        locate = {
          enable = true;
          package = pkgs.plocate;
        };
      };
      systemd.tmpfiles.rules = [
        # Delete old build files after 4 days
        "e /nix/var/nix/builds/* - - - 4d"
      ];
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

      nix = {
        optimise = {
          automatic = true;
          dates = "daily";
        };
      };
      programs = {
        nh = {
          enable = true;
          clean = {
            enable = true;
            dates = "daily";
            extraArgs = "--keep 5 --keep-since 3d";
          };
        };
        zsh.enable = true;
        fish.enable = true;

        nix-ld.enable = true;

        nix-ld.libraries = with pkgs; [
          # Add any missing dynamic libraries for unpackaged programs
          # here, NOT in environment.systemPackages
        ];
      };
    };
}
