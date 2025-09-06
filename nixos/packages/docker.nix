{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx
  ];

  # The worlds most famous _virtualisation_ software....rly nixos?
  virtualisation.docker = {
    enable = true;
  };
}
