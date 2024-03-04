.PHONY: default
default: configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch --impure --flake .#rebuild
# --impure gives access to /etc/nixos/hardware-configuration.nix
