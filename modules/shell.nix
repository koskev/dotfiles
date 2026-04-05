_: {
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            opentofu
            tofu-ls
            nh
            nix
            home-manager
          ];
        };
      };
    };
}
