{lib, ...}:
with lib; {
  imports = [
    ./ssd.nix
    ./power.nix
    ./memory.nix
  ];

  options.my.hardware = {
    display = {
      internalBacklight = mkOption {
        type = types.bool;
        default = false;
        description = "Has an internal display with controllable backlight";
      };

      ddc = mkOption {
        type = types.bool;
        default = false;
        description = "Supports DDC/CI for external monitors";
      };
    };

    gpu = mkOption {
      type = types.enum ["nvidia" "amd" "intel" "none"];
      default = "none";
      description = "GPU vendor";
    };

    hybrid = mkOption {
      type = types.bool;
      default = false;
    };

    prime = {
      intelBusId = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      nvidiaBusId = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };
}
