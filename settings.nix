{ ... }:
{
  system = "x86_64-linux";
  nixos = {
    "kevin-nix" = {
    };
  };
  users = {
    "kevin@kevin-arch" = {
      profile = "desktop";
    };
    "kevin@kevin-nix" = {
      profile = "desktop";
    };
  };
}
