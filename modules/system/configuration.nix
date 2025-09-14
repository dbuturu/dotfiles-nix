{ config, pkgs, inputs, ... }:

{
    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;

    nixpkgs.config.allowUnfree = true;
    programs.zsh.enable = true;
    home-manager.backupFileExtension = "backup";

    # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
        acpi tlp git
        gnome-themes-extra adwaita-icon-theme
        inputs.nixvim.packages.${system}.default
    ];

    # Install fonts
    fonts = {
        packages = with pkgs; [
            jetbrains-mono
            roboto
            openmoji-color
            nerd-fonts.jetbrains-mono
        ];

        fontconfig = {
            hinting.autohint = true;
            defaultFonts = {
              emoji = [ "OpenMoji Color" ];
            };
        };
    };


    # Wayland stuff: enable XDG integration, allow sway to use brillo
    xdg = {
        portal = {
            enable = true;
            extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
            ];
        };
    };

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "dbuturu" ];
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
        '';
    };

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        tmp.cleanOnBoot= true;
        loader = {
            systemd-boot.enable = true;
            systemd-boot.editor = false;
            efi.canTouchEfiVariables = true;
            timeout = 0;
        };
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "Africa/Nairobi";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
    };

    # Set up user and enable sudo
    users.users.dbuturu = {
        isNormalUser = true;
        extraGroups = [ "input" "wheel" ];
        shell = pkgs.zsh;
        packages = with pkgs.gitAndTools; [
            git-absorb    # Auto-squash feature branch commits
            git-extras    # Additional Git commands
            git-open      # Open repository in browser
        ];
    };
    
    # Enable networking
    networking.networkmanager.enable = true;
  
    networking.nameservers = [ "45.90.28.0#f6f6f3.dns.nextdns.io" "45.90.30.0#f6f6f3.dns.nextdns.io" ];

    services.resolved = {
        enable = true;
        dnssec = "true";
        domains = [ "~." ];
        fallbackDns = [ "45.90.28.0#f6f6f3.dns.nextdns.io" "45.90.30.0#f6f6f3.dns.nextdns.io" ];
        dnsovertls = "true";
    };
 
    # Set up networking and secure it
    networking = {
        wireless.iwd.enable = true;
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;
        };
    };

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_DATA_HOME = "$HOME/.local/share";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
        GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
        MOZ_ENABLE_WAYLAND = "1";
        ZK_NOTEBOOK_DIR = "$HOME/notes/";
        EDITOR = "nvim";
        DIRENV_LOG_FORMAT = "";
        ANKI_WAYLAND = "1";
        DISABLE_QT5_COMPAT = "0";
    };

    environment.sessionVariables = {
        # If your cursor becomes invisible
        WLR_NO_HARDWARE_CURSORS = "1";
        # Hint electron apps to use wayland
        NIXOS_OZONE_WL = "1";
    };
    
    # Security 
    security = {
        sudo.enable = false;
        doas = {
            enable = true;
            extraRules = [{
                users = [ "dbuturu" ];
                keepEnv = true;
                persist = true;
            }];
        };

        # Extra security
        protectKernelImage = true;
    };

    # Sound

    security.rtkit.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    
    # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
    hardware = {
        bluetooth.enable = true;
        graphics.enable = true;
        # Enable NVIDIA proprietary driver
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = true;
            open = false; # Use proprietary driver (recommended for 940MX)
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
        # If you want to use PRIME offloading (for hybrid graphics laptops)
        nvidia.prime = {
            sync.enable = true;
            intelBusId = "PCI:0:2:0";    # Replace with your Intel GPU BusID
            nvidiaBusId = "PCI:1:0:0";   # Replace with your NVIDIA GPU BusID
        };
        uinput.enable = true;
    };

    programs.hyprland = {
        # Install the packages from nixpkgs
        enable = true;
        # Whether to enable XWayland
        xwayland.enable = true;
    };

    programs.regreet = {
        enable = true;
        theme.name = "Adwaita-dark";
    };

    environment.variables.GTK_THEME = "Adwaita-dark";  # Optional fallback

    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };
    
    services.printing.enable = true;

    # Do not touch
    system.stateVersion = "24.11";
}
