{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    bash-language-server
    # clangd
    clang-tools
    gopls
    helm-ls
    marksman
    openscad-lsp
    rustup
    bacon
    terraform-ls
    tflint
    yaml-language-server
    pyright
    nodejs

    # nix
    nil
    nixd

    # Debugger
    delve

    # Formatter
    gofumpt
    prettier
    # goimports
    gotools
    golangci-lint
    golangci-lint-langserver
    golines
    gomodifytags

    inputs.grustonnet.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    inputs.vrl-ls.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    inputs.jsonnet-debugger.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];
}
