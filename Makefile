HOST := Jeanres-MacBook-Pro
FLAKE := .\#$(HOST)

.PHONY: help install build switch update check gc

help: ## Show available targets
	@grep -E '^[a-z]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

NIX := /nix/var/nix/profiles/default/bin/nix

install: ## Fresh Mac: install CLT, Lix, Homebrew, then nix-darwin
	@xcode-select -p >/dev/null 2>&1 || { \
		echo "Installing Xcode Command Line Tools; re-run 'make install' when done"; \
		xcode-select --install; exit 1; }
	@test -x $(NIX) || curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
	@test -x /opt/homebrew/bin/brew || NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	sudo $(NIX) --extra-experimental-features "nix-command flakes" \
		run nix-darwin/master#darwin-rebuild -- switch --flake $(FLAKE)

build: ## Build the system without activating it
	darwin-rebuild build --flake $(FLAKE)

switch: ## Build and activate the system
	sudo darwin-rebuild switch --flake $(FLAKE)

update: ## Update flake inputs, then switch
	nix flake update
	$(MAKE) switch

check: ## Evaluate and check the flake
	nix flake check

gc: ## Delete old generations and collect garbage
	sudo nix-collect-garbage --delete-older-than 30d
