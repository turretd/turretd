{ sources ? import ../nix/sources.nix, pkgs ? import sources.nixpkgs {}, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}