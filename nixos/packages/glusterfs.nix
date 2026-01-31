{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    glusterfs
  ];

}
