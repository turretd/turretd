let 
    sources = import ./nix/sources.nix;
    pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
    buildInputs = with pkgs; [ 
        nixfmt niv
        terraform terragrunt awscli2 
        fd ripgrep rage
        nodejs yarn
    ];
    shellHook = ''
        export PATH="$PWD/bin:$PATH"
        export NIX_CONF_DIR="$PWD"
    '';
}