{inputs}: final: prev: {
  stable = import inputs.nixpkgs-stable {
    inherit (final.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
}
# Add stable.<package> before any package to use it
# Examples:
#
# programs.foo = {
#   enable = true;
#   package = pkgs.stable.foo;
# };
#
# home.packages = with pkgs; [
#   stable.foo
# ];
