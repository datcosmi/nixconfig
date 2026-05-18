{lib, ...}:
with lib; {
  imports = [
    ./ssd.nix
    ./power.nix
    ./memory.nix
    ./keyboard.nix
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

    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "XKB keyboard layout";
      };

      keyMap = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Console keyboard layout";
      };

      variant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "XKB keyboard variant";
      };
    };

    gpu = {
      vendor = mkOption {
        type = types.enum ["nvidia" "amd" "intel" "none"];
        default = "none";
        description = "GPU vendor";
      };

      openDrivers = mkOption {
        type = types.bool;
        default = false;
        description = "Use open-source NVIDIA kernel modules (Turing/RTX 20xx+ only)";
      };
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

    hasWifi = mkOption {
      type = types.bool;
      default = false;
      description = "Has a wifi antenna";
    };
  };
}
