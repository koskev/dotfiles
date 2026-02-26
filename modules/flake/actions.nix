{ inputs, ... }:
let
  actions = {
    checkout = "actions/checkout@v5";
    nothing-but-nix = "wimpysworld/nothing-but-nix@687c797a730352432950c707ab493fcc951818d7";
    cachix-installer = "cachix/install-nix-action@v31";
  };
  configs = [
    "kevin-nix"
    "kevin-laptop"
    "kokev"
  ];
  hm_configs = [
    "kevin@kevin-nix"
    "kko@liag0005"
  ];
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];
  flake.actions-nix = {
    pre-commit.enable = true;
    # defaults was renamed to defaultValues to avoid conflict
    # with GitHub option
    # https://github.com/nialov/actions.nix/issues/11
    # defaults = {
    defaultValues = {
      jobs = {
        runs-on = "ubuntu-latest";
      };
    };
    workflows = {
      ".github/workflows/build.yaml" = {
        name = "Build Nix Configurations";
        on = {
          push = { };
        };
        jobs = {
          build = {
            steps = [
              {
                uses = actions.checkout;
              }
              {
                name = "Most important Action!";
                uses = actions.nothing-but-nix;
                "with".hatchet-protocol = "rampage";
              }
              {
                name = "Install nix";
                uses = actions.cachix-installer;
                "with".github_access_token = "\${{ secrets.GITHUB_TOKEN }}";
              }
              {
                name = "Check flake";
                run = "nix flake check";
              }
            ]
            ++ map (value: {
              name = "Build NixOS for ${value}";
              run = "nix run nixpkgs#nixos-rebuild -- --flake .#${value} build";
            }) configs

            ++ map (value: {
              name = "Build HomeManager for ${value}";
              run = "nix run nixpkgs#home-manager -- --flake .#${value} build";
            }) hm_configs;
          };
        };
      };
    };
  };
}
