{ sources ? import ../../nix/sources.nix , pkgs ? import sources.nixpkgs {}, npmlock2nix ? import sources.npmlock2nix {} }:
let 
    src = sources.cryptid;
in
npmlock2nix.build {
    pname = "cryptid";
    version = "unknown";
    src = src;
    installPhase = "cp -r dist $out";
    buildCommands = [ "npx webpack build" ];
}
