_: {
  flake.nixosModules.kubernetes =
    {
      self,
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.glusterfs
      ];

      environment.systemPackages = with pkgs; [
        kubernetes
        kubectl
      ];
    };
}
