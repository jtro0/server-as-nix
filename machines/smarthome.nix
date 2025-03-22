{ config, pkgs, ... }:

{
    networking = {
        interfaces.eth0 = {
            ipv4.addresses = [
                {
                    address = "192.168.1.50";
                    prefixLength = 24;
                }
            ];
        };
        defaultGateway = "192.168.1.1";
        nameservers = [ "8.8.8.8" "1.1.1.1" ];
    };
}