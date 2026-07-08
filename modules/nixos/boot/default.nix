{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.theme;
in {
  imports = [
    ./nvidia.nix
    ./plymouth.nix
  ];

  config = lib.mkMerge [
    {
      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };

          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = false;
            configurationLimit = 6;
          };

          timeout = lib.mkDefault 3;
        };

        kernelPackages = pkgs.linuxPackages_latest;
        # kernelPackages = pkgs.linuxPackages_6_12;

        kernelParams = [
          "mem_sleep_default=deep"
          "elevator=mq-deadline"
        ];
      };

      # Automatically copy GRUB entries into BIOS fallback EFI path each rebuild (in case a BIOS flash removes them from NVRAM)
      system.activationScripts.syncFallbackEfi = {
        text = ''
          mkdir -p /boot/EFI/BOOT
          cp /boot/EFI/NixOS-boot/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI
        '';
        deps = [];
      };
    }

    (lib.mkIf (cfg.palette == "catppuccin-mocha") {
      catppuccin = {
        grub = {
          enable = lib.mkDefault true;
          flavor = lib.mkDefault "mocha";
        };
      };
    })
  ];
}
