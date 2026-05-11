{
  lib,
  inputs,
}: let
  hmModule = inputs.home-manager.nixosModules.home-manager;
in rec {
  mkHost = {
    hostname,
    system,
    users ? [],
  }:
    lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs;};

      modules = [
        ./hosts/${hostname}
        ./modules/nixos/common.nix

        inputs.disko.nixosModules.disko
        inputs.catppuccin.nixosModules.catppuccin

        hmModule
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
            inherit users;
            sharedModules = [
              inputs.catppuccin.homeModules.catppuccin
            ];
            users =
              lib.genAttrs users
              (u: import ./users/${u}/home.nix);
          };
        }

        {
          users.users =
            lib.genAttrs users
            (u: import ./users/${u}/default.nix {inherit lib;});
        }
      ];
    };

  mkUser = {
    username,
    groups ? [],
    shell ? null,
  }:
    {
      isNormalUser = true;
      inherit groups;
    }
    // lib.optionalAttrs (shell != null) {inherit shell;};
}
