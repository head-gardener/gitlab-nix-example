{
  networking.networkmanager.enable = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowPing = false;

  system.stateVersion = "24.05";

  programs = {
    atop = {
      enable = true;
      atopService.enable = true;
      atopRotateTimer.enable = true;
      settings = {
        interval = 5;
        flags = "1fA";
      };
    };
  };
}
