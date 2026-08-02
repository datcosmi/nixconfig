{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "nix-flake-update-commit";
      runtimeInputs = with pkgs; [ git jq nix ];
      text = builtins.readFile ./nix-flake-update-commit.sh;
    })
  ];
}
