{ inputs, ... }:
let
  inherit (inputs.nix-actions.lib) actions;
  ubuntu_image = "ubuntu-24.04";
  systems = {
    x86_64-linux = {
      image = ubuntu_image;
      configs = [
        "kevin-nix"
        "kevin-laptop"
        "kokev"
      ];
      hm_configs = [
        "kevin@kevin-nix"
        "kko@liag0005"
      ];
    };
    aarch64-linux = {
      image = "${ubuntu_image}-arm";
      configs = [ "rpi-drucker" ];
      hm_configs = [ ];
    };
  };
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];
  flake.actions-nix = { lib, ... }: {
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
        jobs = lib.concatMapAttrs (name: value: {
          "build_${name}" = {
            runs-on = value.image;
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
                uses = actions.cachix;
                "with".name = "koskev";
              }
              {
                name = "Check flake";
                run = "nix flake check";
              }
            ]
            ++ map (value: {
              name = "Build NixOS for ${value}";
              run = "nix run nixpkgs#nixos-rebuild -- --flake .#${value} build --accept-flake-config";
            }) value.configs

            ++ map (value: {
              name = "Build HomeManager for ${value}";
              run = ''NIX_CONFIG="accept-flake-config = true" nix run nixpkgs#home-manager -- --flake  .#${value} build'';
            }) value.hm_configs
            ++ inputs.nix-actions.lib.mkCachixSteps {
              branches = [
                "main"
                "renovate/lock-file-maintenance"
              ];
              target = ".#push";
            };
          };
        }) systems;
      };
    };
  };
}
