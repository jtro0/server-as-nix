{ config, lib, pkgs, ... }:

{
  # Common configuration for all systems
  system.stateVersion = "24.05";

  # Basic system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    python3
  ];

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
		settings.PasswordAuthentication = false;
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

	# Enable mDNS for `hostname.local` addresses
	services.avahi.enable = true;
	services.avahi.nssmdns4 = true;
	services.avahi.publish = {
		enable = true;
		addresses = true;
	};

  # Create a default user
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = lib.fileContents "/run/secrets/admin_passwd";
    openssh.authorizedKeys.keys = [lib.fileContents "/run/secrets/ssh_server_pub"];
  };
	security.sudo.wheelNeedsPassword = false;

		# Allow remote updates with flakes and non-root users
	nix.settings.trusted-users = [ "root" "@wheel" ];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable tailscale
    services.tailscale = {
        enable = true;
        authKeyFile = "/run/secrets/tailscale-authkey";
    };
}
