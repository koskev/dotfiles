_: {
  perSystem =
    {
      self',
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
            self'.packages.atuin
          ];
        };
        atuin = pkgs.atuin.overrideAttrs (oldAttrs: rec {
          # Prevent atuin from even being able to send the history to an LLM (like WTF?! Do I really want to use the software in this state?)
          cargoBuildFeatures = [
            "client"
          ];
          buildFeatures = cargoBuildFeatures;
          doCheck = false;
        });
      };
    };
}
