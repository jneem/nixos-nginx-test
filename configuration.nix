{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    
  ];

  nix = {
    #registry.nixpkgs.flake = nixpkgs;
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
}
