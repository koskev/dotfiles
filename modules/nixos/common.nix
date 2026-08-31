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
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://koskev.cachix.org"
        ];
        trusted-public-keys = [
          "koskev.cachix.org-1:1EexePRC9DgMPKI01zWTxM9YRIWHBbev15hTUE6h50I="
        ];
      };
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

      # Configuration.nix common
      time.timeZone = "Europe/Amsterdam";
      i18n.defaultLocale = "en_DK.UTF-8";
      console = {
        font = "Lat2-Terminus16";
        keyMap = "de";
      };
      users.users.root = {
        shell = config.hostSettings.root.shell;
        openssh.authorizedKeys.keys = config.hostSettings.root.keys;
      };
      services.openssh.settings.PasswordAuthentication = false;

      system.stateVersion = config.hostSettings.stateVersion; # Did you read the comment?
    };
}
