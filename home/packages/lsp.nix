{
  pkgs,
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
    rust-analyzer
    terraform-ls
    tflint
    yaml-language-server
    pyright

    # Debugger
    delve

    # Formatter
    gofumpt
    # goimports
    gotools
    golangci-lint
    golangci-lint-langserver
    golines
    gomodifytags

  ];
}
