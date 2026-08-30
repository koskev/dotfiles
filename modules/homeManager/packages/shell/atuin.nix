{ self, ... }: {
  flake.modules.homeManager.shell = { lib, pkgs, ... }: {
    programs = {
      fzf.historyWidget.command = lib.mkForce "";
      atuin = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.atuin;
        flags = [ "--disable-up-arrow" ];
        enableZshIntegration = true;
        enableFishIntegration = true;
        settings = {
          enter_accept = "false";
        };
      };
    };
  };
}
