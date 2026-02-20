_: {
  flake.modules.nixos.kubernetes =
    {
      self,
      pkgs,
      ...
    }:
    {
      imports = [
        self.modules.nixos.glusterfs
      ];

      environment.systemPackages = with pkgs; [
        kubernetes
        kubectl
      ];
    };
}
