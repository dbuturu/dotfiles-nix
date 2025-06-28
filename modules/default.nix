{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "24.11";
    imports = [
        # gui
        ./firefox
        ./foot
        ./st
        ./ghostty
        ./dunst
        ./hyprland
        ./wofi
        ./winbox4

        # cli
        ./nvim
        ./zsh
        ./git
        ./gpg
        ./direnv

        # system
        ./xdg
	    ./packages
        inputs.xremaps-flake.homeManagerModules.default
        ./xremap
    ];
}
