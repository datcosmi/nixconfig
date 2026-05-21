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
            system.activationScripts.createNixUserProfiles = lib.stringAfter ["users"] ''
              for user in ${lib.concatStringsSep " " userNames}; do
                home=$(getent passwd $user | cut -d: -f6)
                mkdir -p /nix/var/nix/profiles/per-user/$user
                chown $user:users /nix/var/nix/profiles/per-user/$user
                mkdir -p /nix/var/nix/gcroots/per-user/$user
                chown $user:users /nix/var/nix/gcroots/per-user/$user
                mkdir -p $home/.local/state/nix/profiles
                mkdir -p $home/.local/share
                mkdir -p $home/.config
                mkdir -p $home/.cache
                chown -R $user:users $home
              done
            '';

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
