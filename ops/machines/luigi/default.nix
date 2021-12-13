{ config, pkgs, ...}: 
{
    deployment.targetHost = "luigi.local";
    networking.hostName = "luigi";
    services.prometheus.enable = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.device = "/dev/sda1"; # or "nodev" for efi only
}