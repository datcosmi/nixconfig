{pkgs, ...}: {
  imports = [
    ./cliphist.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim
    stow
    cachix
    exfatprogs

    # cabextract
    # xrandr
    # vulkan-tools

    # nvtopPackages.nvidia
  ];
}
