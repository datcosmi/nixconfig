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

      modules =
        [
          ../hosts/${hostname}
          ../modules/nixos/common.nix
          ../users

          inputs.disko.nixosModules.disko
          inputs.catppuccin.nixosModules.catppuccin

          hmModule

          {my.users = users;}

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                inputs.catppuccin.homeModules.catppuccin
              ];
              users =
                lib.genAttrs users
                (u: import ../users/${u}/home.nix);
            };
          }
        ]
        ++ map (u: ../users/${u}/default.nix) users;
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
