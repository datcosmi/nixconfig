{
  lib,
  inputs,
}: let
  hmModule = inputs.home-manager.nixosModules.home-manager;
  diskoModule = inputs.disko.nixosModules.disko;
  catpModule = inputs.catppuccin.nixosModules.catppuccin;
  stableOverlay = import ../overlays/nixpkgs-stable.nix {inherit inputs;};
  shairport-mpris = import ../overlays/shairport-sync-mpris.nix;
in rec {
  mkHost = {
    hostname,
    system,
    users ? [],
  }:
    lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs hostname;} // {helpers = {inherit mkUser;};};

      modules =
        [
          (inputs.import-tree ../hosts/${hostname})
          (inputs.import-tree ../modules/options)
          (inputs.import-tree ../modules/nixos)

          hmModule
          diskoModule
          catpModule

          {my.users = users;}
          {nixpkgs.overlays = [stableOverlay shairport-mpris];}

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              extraSpecialArgs = {inherit inputs hostname;};
              sharedModules = [
                (inputs.import-tree ../modules/options)
                (inputs.import-tree ../modules/home)
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
    description ? username,
    home ? "/home/${username}",
    extraGroups ? [],
    shell ? null,
  }: {
    users.users.${username} =
      {
        isNormalUser = true;
        inherit description home extraGroups;
        createHome = true;
      }
      // lib.optionalAttrs (shell != null) {inherit shell;};
  };
}
