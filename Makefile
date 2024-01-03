.PHONY: default
default:
	sudo nixos-rebuild switch --flake .#rebuild
