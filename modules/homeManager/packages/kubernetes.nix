_: {
  flake.modules.homeManager.kubernetes =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kubectl
        krew
      ];

    };
}
