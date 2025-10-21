{ settings, ... }:
{
  imports = [
    ./home/profiles/${settings.profile}.nix
    ./home/profiles/common.nix
  ];
}
