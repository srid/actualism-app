default:
    @just --list

# Run hoogle
docs:
    echo http://127.0.0.1:8888
    hoogle serve -p 8888 --local

# Run cabal repl
repl *ARGS:
    cabal repl {{ARGS}}

# Autoformat the project tree
fmt:
    treefmt

# Run ghciwatch -- auto-recompile and run `main` function
run:
    ghcid -T :main

# Deploy the app to our NixOS VM (Hetzner)
deploy:
    # Build locally and copy the Haskell binary first,
    # since nixos-unified cannot do that yet:
    # https://github.com/srid/nixos-unified/issues/90
    nix copy \
        $(nix build --no-link --print-out-paths) \
        --to ssh-ng://root@5.161.237.23 \
        --no-check-sigs
    nix run .#activate actualism-app

# SSH into the NixOS VM
ssh:
    ssh root@5.161.237.23