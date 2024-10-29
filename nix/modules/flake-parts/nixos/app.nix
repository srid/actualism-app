{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  actualism-app = self.packages.${pkgs.system}."actualism-app";
in
{
  networking.firewall.allowedTCPPorts = [ 22 80 442 ];

  services.nginx = {
    enable = true;
    virtualHosts."actualism.app" = {
      addSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:3000";
    };
  };

  # systemd service for the app
  systemd.services.actualism-app = {
    description = "actualism-app";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe actualism-app}";
      Restart = "always";
    };
  };

  # Setup ACME SSL
  security.acme = {
    acceptTerms = true;
    defaults.email = "srid@srid.ca";
  };
}
