{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.lsp;
in {
  options.my.features.dev.lsp.enable = lib.mkEnableOption "Install lsp's and formatters";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # LSP's
      lua-language-server
      rust-analyzer
      tailwindcss-language-server
      typescript-language-server
      vscode-langservers-extracted
      svelte-language-server
      pyright
      astro-language-server

      # Formatters
      stylua
      isort
      black
      rustc
      rustfmt
      prettierd
      prettier
      alejandra
      kdlfmt
    ];
  };
}
