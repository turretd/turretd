let 
    sources = import ./nix/sources.nix;
    pkgs = import sources.nixpkgs {};
    nixos-shell = import sources.nixos-shell {};
    nixos-generators = import sources.nixos-generators;
    tools = import ./nix { pkgs = pkgs; };
in
pkgs.mkShell {
    buildInputs = with pkgs; [ 
        nixfmt niv nixos-shell nixos-generators
        terraform terragrunt awscli2 docker kubectl
        fd ripgrep rage sops entr gnumake
        nodejs yarn  
        tools.friend tools.build-containers
    ];
    shellHook = ''
        export DIRENV_LOG_FORMAT=
        export NIX_CONF_DIR="$PWD"
    '';
}