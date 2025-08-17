{ ... }:
{
  system = "x86_64-linux";
  stateVersion = "25.11"; # Did you read the comment?
  hosts = {
    "kevin-arch" = {
      nixos = false;
      users.kevin.profile = "desktop";
    };
    "kevin-nix" = {
      nixos = true;
      users.kevin.profile = "desktop";
    };
    "liag0005" = {
      nixos = false;
      users.kko.profile = "work";
    };
  };
}
