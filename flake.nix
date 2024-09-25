{
  inputs.config.url = "github:head-gardener/config";

  outputs = { config, ... }:
    let nixpkgs = config.inputs.nixpkgs;
    in {

      nixosConfigurations.gitlab-dev = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix/gitlab-ce.nix
          ./nix/configuration.nix
          ({ lib, ... }: {
            networking.firewall.enable = lib.mkForce false;
            boot.isContainer = true;
            programs.atop.enable = lib.mkForce false;
            services.gitlab.host = "10.233.1.2";
            services.gitlab.port = 80;
          })
          "${nixpkgs}/nixos/modules/virtualisation/container-config.nix"
        ];
      };

      nixosConfigurations.gitlab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix/gitlab-ce.nix
          ./nix/configuration.nix
          (config.lib.mkKeys config "hunter")
          "${config}/modules/zram.nix"
          "${config}/modules/default/tools.nix"
          "${config}/modules/default/users.nix"
          "${config}/modules/default/openssh.nix"
          "${config}/modules/default/tmux.nix"
          {
            swapDevices = [{
              device = "/swapfile";
              size = 5120;
            }];
          }
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
        ];
      };

    };
}
