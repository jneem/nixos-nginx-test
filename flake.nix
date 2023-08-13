{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blog.url = "github:jneem/blog";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "aarch64-linux";
      #system = "x86_64-linux";
    in {
      nixosConfigurations.treeman-ranch = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;

        modules = [
          (import ./configuration.nix)
          (import ./blog-server.nix { inherit inputs; })
          {
            system.stateVersion = "23.05";
          }
        ];
      };
    };
}
