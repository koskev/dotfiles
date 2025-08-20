{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
  ];

  programs.k9s = {
    enable = true;
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
