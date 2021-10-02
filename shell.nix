let 
    sources = import ./nix/sources.nix;
    pkgs = import sources.nixpkgs {};
    nixos-shell = import sources.nixos-shell {};
    nixos-generators = import sources.nixos-generators;
in
pkgs.mkShell {
    buildInputs = with pkgs; [ 
        nixfmt niv nixos-shell nixos-generators
        terraform terragrunt awscli2 
        fd ripgrep rage sops entr gnumake
        nodejs yarn
    ];
    shellHook = ''
        export DIRENV_LOG_FORMAT=
        export PATH="$PWD/bin:$PATH"
        export NIX_CONF_DIR="$PWD"
    '';
}