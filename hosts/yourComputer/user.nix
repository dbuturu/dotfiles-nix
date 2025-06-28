{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        firefox.enable = false;
        foot.enable = false;
        st.enable = false;
        ghostty.enable = true; # ghostty terminal emulator
        dunst.enable = true;
        hyprland.enable = true;
        wofi.enable = true;
        winbox4.enable = true;

        # cli
        nvim.enable = true;
        zsh.enable = true;
        git.enable = true;
        gpg.enable = true;
        direnv.enable = true;

        # system
        xdg.enable = true;
        packages.enable = true;
        xremap.enable = true;
    };
}
