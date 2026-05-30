{pkgs, ...}: {
  boot.kernelParams = [
    "drm.edid_firmware=DP-1:/lib/firmware/edid/dp1.bin"
  ];

  hardware.firmware = [
    (pkgs.runCommand "dp1-edid-firmware" {} ''
      mkdir -p $out/lib/firmware/edid
      cp ${./dp1.bin} $out/lib/firmware/edid/dp1.bin
    '')
  ];
}
