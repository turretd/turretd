{ sources ? import ../../nix/sources.nix , pkgs ? import sources.nixpkgs {} }:
let 
    src = sources.cryptid;
    crypt_code = pkgs.stdenv.mkDerivation {
    pname = "cryptid";
    version = "unknown";
    src = src;
    installPhase = ''
        cp -r $src $out
    '';
};
in
crypt_code
