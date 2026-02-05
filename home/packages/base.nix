{
  pkgs,
  lib,
  settings,
  nixgl,
  ...
}:
{
  home.packages = with pkgs; [
    fastfetch
    sqlite
    git
    curl
    wget
    nixfmt
    gawk
    gcc
    zsh
    iconv
    lsd
    ripgrep
    unzip
    ncdu
    compsize
    nix
  ];

  # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  programs.gpg = {
    enable = true;
    publicKeys = [
      # Personal Key
      {
        trust = 5;
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEY78xwhYJKwYBBAHaRw8BAQdA2yprP8todlZZt2pEXQbGi8GXk7znuJvrgJ+6
          4m1iUaO0FktldmluIDxrZXZpbkBrb2tldi5kZT6IiQQTFgoAMQIbAwQLCQgHBRUI
          CQoLBRYCAwEAFiEEb4Ua2OR76HjFVjXPvkSbdCDNPGAFAmljbIEACgkQvkSbdCDN
          PGC+JgEA3BLZIG5P1xrOKbYs4NGAmslDVaSBcAnoGwQDtk6QB1kA/2C7+6OQWTwj
          6ACy+T/9DoOMILyiiiKKgOvSY74cOQIGiI8EExYIADcWIQRvhRrY5HvoeMVWNc++
          RJt0IM08YAUCY78xwgUJBaOagAIbAwQLCQgHBRUICQoLBRYCAwEAAAoJEL5Em3Qg
          zTxg0dgA/i9TBssqjlhBNLGsb0bq/zXxrvVQr7NLMB/T2M1U9pOjAQCcBN+18aAw
          XVjah0P59s8RBtBh/629kNGt0eRjP+NfD7g4BGO/McISCisGAQQBl1UBBQEBB0B/
          c1m6i6otVQE1Y0+AqhWtgDJC1qr9ZM90mWEP8aRoBgMBCAeIeAQYFgoAIAIbDBYh
          BG+FGtjke+h4xVY1z75Em3QgzTxgBQJpY2yvAAoJEL5Em3QgzTxgnpABAIuXs5aV
          UHdaHFKg1kO6zY59KXg4aueWLV4OadrgkXZUAP93GSFg/wB3MB67zsC0D5TWqAEK
          Hx2BTk/ijU1ajs52BQ==
          =C69Q
          -----END PGP PUBLIC KEY BLOCK-----
        '';
      }
      # Renovate key
      {
        trust = 5;
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEZ8wQhBYJKwYBBAHaRw8BAQdAnzD8L+/b3vhc0N0ML8VaLOY108KA8+WATWhO
          50g5VP20IXJlbm92YXRlIHNpZ24gPHJlbm92YXRlQGtva2V2LmRlPoiTBBMWCgA7
          FiEEOxySjInSb6RFyzZFF4ZlISETgVwFAmfMEIQCGwMFCwkIBwICIgIGFQoJCAsC
          BBYCAwECHgcCF4AACgkQF4ZlISETgVwYLwD/UQ9q7RqRbTq/otEyZ85mNwuM2zip
          +A0HLLa4jyaYeo4BAMyxpGdrzsR3VE/+i+JkLUjCFITUVxr2pZBi4sauxVYE
          =EogS
          -----END PGP PUBLIC KEY BLOCK-----
        '';
      }
    ];
  };

}

// lib.optionalAttrs (!settings.system.nixos) {
  targets.genericLinux.nixGL = {
    inherit (nixgl) packages;
    vulkan.enable = false;
    defaultWrapper = "mesa";
    installScripts = [
      "mesa"
    ];
  };
}
