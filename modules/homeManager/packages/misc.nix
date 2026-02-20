_: {
  flake.modules.homeManager.misc =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Dependency currently broken and there is `comma` anyways
        #siril
        feishin
        xsane
        statix
        tokei
        borgbackup
        sops
      ];
    };
}
