{pkgs, ...}: {
  imports = [
    ./nvidia.nix
  ];

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

      timeout = 3;
    };

    initrd.systemd.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_6_12;

    kernelParams = [
      "mem_sleep_default=deep"
      "elevator=mq-deadline"
    ];
  };
}
