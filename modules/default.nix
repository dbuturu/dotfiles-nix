{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "24.11";
    imports = [
        # gui
        ./firefox
        ./foot
        ./eww
        ./dunst
        ./hyprland
        ./wofi
        ./electron-web-apps

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
