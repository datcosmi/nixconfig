{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fish;
in {
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      shellAliases = {
        ll = "ls -lh";
        la = "eza --icons=always -a";
        ls = "eza --icons=always";
        lta = "eza --icons=always --tree";

        lsblk-model = "lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,MODEL | bat -l conf -p";

        nix-rebuild = "sudo nixos-rebuild switch --flake ~/nixconfig";

        flake-check = "nix flake check ~/nixconfig";

        flake-update = "cd ~/nixconfig && nix flake update";

        update-nix = "cd ~/nixconfig && nix flake update && sudo nixos-rebuild switch --flake ~/nixconfig";

        list-gen = "nix profile history --profile /nix/var/nix/profiles/system";

        del-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";

        gc = "sudo nix-collect-garbage";

        desk-names-global = "ls /run/current-system/sw/share/applications";

        desk-names-user = "ls /etc/profiles/per-user/(id -un)/share/applications";
      };

      shellAbbrs = {
        nr = "sudo nixos-rebuild switch --flake ~/nixconfig";
        fc = "nix flake check ~/nixconfig";
        fu = "cd ~/nixconfig && nix flake update";
        un = "cd ~/nixconfig && nix flake update && sudo nixos-rebuild switch --flake ~/nixconfig";
      };

      functions = {
        inv = ''
          set files (fzf -m --preview="bat --color=always {}")

          if test (count $files) -gt 0
            nvim $files
          end
        '';
      };

      interactiveShellInit = ''
        fish_vi_key_bindings

        clear
        fastfetch
      '';
    };

    programs.fzf = {
      enableFishIntegration = true;
    };

    programs.zoxide = {
      enableFishIntegration = true;
    };
  };
}
