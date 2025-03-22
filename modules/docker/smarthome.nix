{ config, lib, pkgs, ... }:

{
  # Declarative Docker container configuration
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      homeassistant = {
        image = "homeassistant/home-assistant:stable";
        ports = [ "8123:8123" ];
        volumes = [ "/srv/homeassistant:/config" ];
        restart = "unless-stopped";
      };
    };
  };

  # Allow ports on firewall
  networking.firewall.allowedTCPPorts = [ 8123 ];
}
