set positional-arguments := true

GREEN := '\033[1;32m'
RED := '\033[1;31m'
CLEAR := '\033[0m'
HOSTNAME := `hostname`
FLAKE := trim_end_match(HOSTNAME, ".local")
SYSTEM := "darwinConfigurations." + FLAKE + ".system"
export NIXPKGS_ALLOW_UNFREE := "1"

# Switch to a new generation and clean up
switch: (rebuild-switch) clean

# Build the nix-darwin configuration
build:
    @echo -e "{{ GREEN }}Starting...{{ CLEAR }}"
    darwin-rebuild build --flake .

# Switch to a new generation
rebuild-switch:
    @echo -e "{{ GREEN }}Switching to new generation...{{ CLEAR }}"
    sudo darwin-rebuild switch --flake .

upgrade:
    nix flake update --commit-lock-file

alias optimise-store := optimize-store

# Optimize the nix store
optimize-store:
    nix store optimise

clean:
    @echo -e "{{ GREEN }}Cleaning up...{{ CLEAR }}"
    rm -rf ./result
