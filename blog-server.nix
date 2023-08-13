{ inputs, ... }:
let 
  blogFiles = inputs.blog.packages.aarch64-linux.default;
in
{
  services.nginx = {
    enable = true;
    virtualHosts."neeman.me" = {
      addSSL = true;
      enableACME = true;
      root = blogFiles;
      serverAliases = [ "www.neeman.me" "joe.neeman.me" "www.joe.neeman.me" ];
    };
  };

}

