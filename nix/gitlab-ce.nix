{ pkgs, ... }:
let secrets = import ../secrets/gitlab.nix;
in {
  services.gitlab = {
    enable = true;
    databasePasswordFile = pkgs.writeText "dbPassword" secrets.databasePasswordFile;
    initialRootPasswordFile = pkgs.writeText "rootPassword" secrets.initialRootPasswordFile;
    secrets = {
      secretFile = pkgs.writeText "secret" secrets.secretFile;
      otpFile = pkgs.writeText "otpsecret" secrets.otpFile;
      dbFile = pkgs.writeText "dbsecret" secrets.dbFile;
      jwsFile = pkgs.runCommand "oidcKeyBase" { }
        "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
    };
  };

  services.gitlab-runner = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      localhost = {
        locations."/".proxyPass =
          "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };
  };
}
