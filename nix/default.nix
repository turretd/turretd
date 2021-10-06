{ pkgs }: 
{
    friend = pkgs.writeScriptBin "friend" ''
        echo "friend";
    '';
    build-containers = pkgs.writeScriptBin "build-containers" ''
        shopt -s globstar
        ROOTDIR=`${pkgs.git}/bin/git rev-parse --show-toplevel`
        pushd $ROOTDIR/containers
        for container in **/default.nix; do
            pushd `dirname $container`
            nix-build
            docker load < result
            rm result
            popd
        done     
    '';
}