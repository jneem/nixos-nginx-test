{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    {
      nixosConfigurations.test-nginx = nixpkgs.lib.nixosSystem {
        # Uncomment the following line for a local build
        # system = "aarch64-linux";

        # Comment the following line for a local build
        system = "x86_64-linux";

        modules = [
          {
            imports = [
              ./hardware-configuration.nix
              ./networking.nix # generated at runtime by nixos-infect
    
            ];

            system.stateVersion = "23.05";
            # Uncomment the following line for a build
            nixpkgs.crossSystem.system = "aarch64-linux";

            nix = {
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
            };

            boot.tmp.cleanOnBoot = true;
            zramSwap.enable = true;
            networking.hostName = "nginx-test";
            networking.domain = "";
            services.openssh.enable = true;
            users.users.root.openssh.authorizedKeys.keys = [
              ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpAveBRfqrg7a41+qdOxw5WT3CbEi7dwlgKObSM85YP'' 
            ];

            security.acme = {
              acceptTerms = true;
              defaults.email = "joeneeman@gmail.com";
            };

            networking.firewall = {
              enable = true;
              allowedTCPPorts = [ 22 80 443 ];
            };

            services.nginx = {
              enable = true;
              virtualHosts."neeman.me" = {
                forceSSL = true;
                enableACME = true;
                root = "/var/www";
              };
            };

          }
        ];
      };
    };
}
