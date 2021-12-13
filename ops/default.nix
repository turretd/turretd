{
  meta = {
    nixpkgs = import (import ../nix/sources.nix {}).nixpkgs {};
  };

  defaults = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vim wget curl
    ];
  };
  luigi = import ./machines/luigi;
}