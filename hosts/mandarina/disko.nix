{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults" "umask=0077"];
              };
            };

            nixos = {
              label = "nixos-luks";
              size = "100%";
              content = {
                type = "luks";
                name = "cryptnixos";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                settings = {
                  crypttabExtraOpts = ["discard"];
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];

                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=@"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };

                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=@home"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };

                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=@nix"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };

                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "subvol=@log"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };

                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "subvol=@snapshots"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
