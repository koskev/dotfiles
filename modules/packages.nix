_: {
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      packages = {
        push = pkgs.symlinkJoin {
          name = "push packages";
          paths = [
            inputs'.grustonnet.packages.default
            inputs'.vrl-ls.packages.default
            inputs'.machtnix.packages.default
            inputs'.mergiraf.packages.default
            inputs'.openhmd.packages.default
            inputs'.noctalia.packages.default
            inputs'.difftastic.packages.default
            inputs'.rufaco.packages.default
            inputs'.pushtotalk.packages.default
          ];
        };
      };
    };
}
