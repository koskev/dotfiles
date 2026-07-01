_: {
  perSystem = { pkgs, ... }: {
    apps.glusterfs = {
      type = "app";
      program = pkgs.writeShellApplication {
        name = "get_cert";
        runtimeInputs = with pkgs; [
          openbao
          openssl
          yq-go
          sops
        ];
        text = ''
          ${builtins.readFile ./get_certificate.sh}
        '';
      };
    };
  };
}
