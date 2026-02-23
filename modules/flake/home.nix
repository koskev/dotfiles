_: {
  flake.modules.nixos.homeManager = {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
