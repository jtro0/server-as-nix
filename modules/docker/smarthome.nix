{ config, lib, pkgs, ... }:

{
  # Enable docker
  services.docker.enable = true;

  # Home Assistant service configuration
  services.home-assistant = {
    enable = true;
    package = pkgs.home-assistant;
    configDir = "/svr/homeassistant";
  };

  # Docker containers
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # Homebridge for HomeKit integration
      homebridge = {
        image = "oznu/homebridge";
        ports = [ "51826:51826" ];
        volumes = [ "/svr/homebridge:/homebridge" ];
      };
    };
  };

  # Allow ports on firewall
  networking.firewall.allowedTCPPorts = [ 8123 9000 51826 ];
}
