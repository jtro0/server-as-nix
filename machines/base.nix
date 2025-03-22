{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  # Basic VM settings
  services.qemuGuest.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.growPartition = true;

  # Default filesystem
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # Network configuration
  networking.useDHCP = false;

    # Proxmox VM configuration
  proxmox.qemuConf = {
    cores = 4;
    memory = 4096;
    bios = "seabios";
    net0 = "virtio,bridge=vmbr0";
  };
}
