_: {
  flake.nixosModules.glusterfs =
    {
      self,
      pkgs,
      settings,
      config,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        glusterfs
      ];
      sops = {
        secrets =
          let
            sopsFile = "${self}/secrets/${settings.hostname}/glusterfs.yaml";
          in
          {
            "glusterpem" = {
              inherit sopsFile;
            };
            "glusterkey" = {
              inherit sopsFile;
            };
          };
      };

      services.glusterfs = {
        enable = true;
        tlsSettings = {
          tlsPem = config.sops.secrets.glusterpem.path;
          tlsKeyPath = config.sops.secrets.glusterkey.path;
          caCert = ./rootCA.crt;
        };
      };

      fileSystems = {
        "/mnt/shared_data" = {
          device = "optiplex.lan:/gv0";
          fsType = "glusterfs";
          options = [ "defaults,_netdev" ];
        };
      };
    };
}
