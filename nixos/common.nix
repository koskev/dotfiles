{
  pkgs,
  ...
}:

{
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
