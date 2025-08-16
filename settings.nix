{ ... }:
{
  username = builtins.getEnv "USER";
  homedir = builtins.getEnv "HOME";
  system = "x86_64-linux";
}
