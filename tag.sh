git tag -F - "v$(date +%Y.%m.%d)" <<< "Built with nixpkgs $(jq -r .nodes.nixpkgs.locked.rev flake.lock)"
