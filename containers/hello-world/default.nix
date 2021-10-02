let 
    sources = import ../../nix/sources.nix;
    pkgs = import sources.nixpkgs {};
in
pkgs.dockerTools.buildLayeredImage {
    name = "hello";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
}