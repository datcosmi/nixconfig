{
  pkgs,
  lib,
  ...
}: {
  nix.registry.nixpkgs.flake = import <nixpkgs> {};

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  nix.optimise = {
    automatic = true;
    dates = ["daily"];
    persistent = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [git vim curl];

  security.sudo.wheelNeedsPassword = true;
  services.openssh.enable = true;
}
