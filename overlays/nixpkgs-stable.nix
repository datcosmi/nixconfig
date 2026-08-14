{inputs}: final: prev: {
  stable = import inputs.nixpkgs-stable {
    inherit (final) system;
    config.allowUnfree = true;
  };
}

# Add stable.<package> before any package to use it
# Examples:
#
# programs.neovim.package = pkgs.stable.neovim-unwrapped;
#
# home.packages = with pkgs; [
#   stable.moonlight-qt
# ];
