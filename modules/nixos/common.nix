{
  pkgs,
  lib,
  ...
}: {
  options.my.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Normal human users on this host, used by modules that need to act per-user";
  };

  config = {
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

    environment.systemPackages = with pkgs; [
      git
      vim
      curl
      wget
      cachix
    ];

    security.sudo.wheelNeedsPassword = true;
    services.openssh.enable = true;
  };
}
