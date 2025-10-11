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
  ];

  # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        trust = 5;
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEY78xwhYJKwYBBAHaRw8BAQdA2yprP8todlZZt2pEXQbGi8GXk7znuJvrgJ+6
          4m1iUaO0FktldmluIDxrZXZpbkBrb2tldi5kZT6IjwQTFggANxYhBG+FGtjke+h4
          xVY1z75Em3QgzTxgBQJjvzHCBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQ
          vkSbdCDNPGDR2AD+L1MGyyqOWEE0saxvRur/NfGu9VCvs0swH9PYzVT2k6MBAJwE
          37XxoDBdWNqHQ/n2zxEG0GH/rb2Q0a3R5GM/418PuDgEY78xwhIKKwYBBAGXVQEF
          AQEHQH9zWbqLqi1VATVjT4CqFa2AMkLWqv1kz3SZYQ/xpGgGAwEIB4h+BBgWCAAm
          FiEEb4Ua2OR76HjFVjXPvkSbdCDNPGAFAmO/McIFCQWjmoACGwwACgkQvkSbdCDN
          PGDV2QEAg9mLVXiulRih4PuL+6PPtAV18K2lyUSvMFD+GvRJzRYBALGSXEF8jtyU
          x2tAeGDdTwNp7boURyTZvgnR6OZy4CEB
          =OW4w
          -----END PGP PUBLIC KEY BLOCK-----
        ''

        ;
      }
    ];
  };

}

// lib.optionalAttrs (!settings.system.nixos) {
  nixGL = {
    inherit (nixgl) packages;
    vulkan.enable = false;
    defaultWrapper = "mesa";
    installScripts = [
      "mesa"
    ];
  };
}
