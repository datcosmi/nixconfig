{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fastfetch;
in {
  options.my.features.shell.fastfetch.enable = lib.mkEnableOption "Enable fastfetch shell";

  config = lib.mkIf cfg.enable {
    home.file. ".config/fastfetch/luna.txt".source = ./luna.txt;

    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          source = "$HOME/.config/fastfetch/luna.txt";
          padding = {
            top = 1;
            left = 2;
          };
          type = "file";
          color = {
            "1" = "38;2;245;194;231";
          };
        };

        display = {
          separator = " ";
        };

        modules = [
          {
            key = "╭───────────╮";
            type = "custom";
          }
          {
            key = "│ {#31} user    {#keys}│";
            type = "title";
            format = "{user-name}";
          }
          {
            key = "│ {#32}󰇅 hname   {#keys}│";
            type = "title";
            format = "{host-name}";
          }
          {
            key = "│ {#33}󰅐 uptime  {#keys}│";
            type = "uptime";
          }
          {
            key = "│ {#34}{icon} distro  {#keys}│";
            type = "os";
          }
          {
            key = "│ {#35} kernel  {#keys}│";
            type = "kernel";
          }
          {
            key = "│ {#36}󰇄 desktop {#keys}│";
            type = "de";
          }
          {
            key = "│ {#31} term    {#keys}│";
            type = "terminal";
          }
          {
            key = "│ {#32} shell   {#keys}│";
            type = "shell";
          }
          {
            key = "│ {#33}󰍛 cpu     {#keys}│";
            type = "cpu";
            showPeCoreCount = true;
          }
          {
            key = "│ {#34}󰉉 disk    {#keys}│";
            type = "disk";
            folders = "/";
          }
          {
            key = "│ {#35} memory  {#keys}│";
            type = "memory";
          }
          {
            key = "├───────────┤";
            type = "custom";
          }
          {
            key = "│ {#39} colors  {#keys}│";
            type = "colors";
            symbol = "circle";
          }
          {
            key = "╰───────────╯";
            type = "custom";
          }
        ];
      };
    };
  };
}
