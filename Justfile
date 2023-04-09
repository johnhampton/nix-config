set positional-arguments

GREEN := '\033[1;32m'
RED := '\033[1;31m'
CLEAR := '\033[0m'

HOSTNAME := `hostname`
FLAKE := trim_end_match(HOSTNAME, ".local")
SYSTEM := "darwinConfigurations." + FLAKE +".system"

export NIXPKGS_ALLOW_UNFREE := "1"

# Show this list of recipes
help: 
  @just --list --unsorted

# Switch to a new generation and clean up
switch *args='': (rebuild-switch args) clean

# Build the nix-darwin configuration
build *args='':
  @echo -e "{{GREEN}}Starting...{{CLEAR}}"
  nix --experimental-features 'nix-command flakes' build .#{{SYSTEM}} --impure $@

# Switch to a new generation
rebuild-switch *args='': (build args)
  @echo -e "{{GREEN}}Switching to new generation...{{CLEAR}}"
  ./result/sw/bin/darwin-rebuild switch --flake .#{{FLAKE}} --impure $@

clean:
  @echo -e "{{GREEN}}Cleaning up...{{CLEAR}}"
  rm -rf ./result


