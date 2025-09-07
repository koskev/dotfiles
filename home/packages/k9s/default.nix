{
  pkgs,
  ...
}:
{
  xdg.configFile = {
    "k9s/skins/" = {
      recursive = true;
      source =
        pkgs.fetchFromGitHub {
          owner = "derailed";
          repo = "k9s";
          rev = "e99c7354307afa43d415c52cd32918c5efbe103b";
          sha256 = "VyOie4ltWy/BJ6MJ9gdSxk1V1PxXpsIkRrhWgXoaUUc=";
        }
        + "/skins";
    };
    "k9s/skins/orange.yaml" = {
      source = ./skins/orange.yaml;
    };
  };

  programs.k9s =
    let
      k9sWrapper = pkgs.writeShellApplication {
        name = "k9s";
        runtimeInputs = [ pkgs.k9s ]; # injects an "export PATH"
        text = builtins.readFile ./k9s_wrapper.sh;
      };
    in
    {
      enable = true;
      package = k9sWrapper;
      aliases = {
        dep = "apps/v1/deployments";
      };
      hotKeys = {
        shift-1 = {
          shortCut = "Shift-1";
          description = "Viewing pods";
          command = "pods";
        };
        shift-2 = {
          shortCut = "Shift-2";
          description = "Deployments";
          command = "deployment";
        };
        shift-3 = {
          shortCut = "Shift-3";
          description = "Configmap";
          command = "configmap";
        };
        shift-4 = {
          shortCut = "Shift-4";
          description = "Secret";
          command = "secret";
        };
      };
    };
}
