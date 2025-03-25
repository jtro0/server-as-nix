{ config, lib, pkgs, ... }:

{
  # Docker containers
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # Home Assistant
      homeassistant = {
        image = "homeassistant/home-assistant:stable";
        ports = [ "8123:8123" ];
        volumes = [ "/srv/homeassistant:/config" ];
        restart = "unless-stopped";
      };
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