_: {
  flake.modules.nixos.kubernetes =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        kubernetes
        kubectl
      ];
    };
}
