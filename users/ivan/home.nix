{...}: {
  imports = [
    ../../modules/home
    ./shell.nix
  ];

  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "26.05";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "garcia.cli@pm.me";
        name = "Iván García";
      };
    };
  };

  my.theme = {
    palette = "catppuccin-mocha";
    gtk = "adwaita";
    cursor = "bibata-ice";
  };
}
