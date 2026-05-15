{
  lib,
  inputs,
}: let
  hmModule = inputs.home-manager.nixosModules.home-manager;
  diskoModule = inputs.disko.nixosModules.disko;
  catpModule = inputs.catppuccin.nixosModules.catppuccin;
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

          hmModule
          diskoModule
          catpModule

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
