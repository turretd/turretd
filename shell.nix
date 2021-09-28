let 
    sources = import ./nix/sources.nix;
    pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
    buildInputs = with pkgs; [ nixfmt terraform terragrunt fd ripgrep awscli2];
}