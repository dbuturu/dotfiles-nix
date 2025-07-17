{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cfg = config.modules.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
in
{
  options.modules.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    # Packages that don't have a dedicated module or don't need one.
    # hyprland, dunst, wofi, ghostty and pipewire are installed via their modules.
    home.packages = with pkgs; [
      swaybg
      wlsunset
      wl-clipboard
      brightnessctl
      playerctl
      grimblast
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = null; # Use system-level Hyprland (recommended for NixOS)
      xwayland.enable = true;

      plugins = [
        (pkgs.callPackage ./hyprriver.nix { hyprlandPlugins = pkgs.hyprlandPlugins; hyprland = pkgs.hyprland; })
      ];  # Add any additional plugins here

      #pluginsConfig = {
      #  hyprriver = {
      #    enable = true;
      #    package = inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprriver;
      #  };
      #};

      settings = {
        monitor = [ "eDP-1,1920x1080@60,0x0,1" ];

        input = {
          kb_layout = "jp";
          follow_mouse = 0;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        general = {
          windowrulev2 = [ "noblur,class:^()$,title:^()$" ];
          gaps_in = 10;
          gaps_out = 10;
          border_size = 3;
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 0.85;
          inactive_opacity = 0.75;
          fullscreen_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            ignore_opacity = true;
            new_optimizations = true;
          };
        };

        animations = {
          enabled = true;
          bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.0" ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, myBezier, popin 80%"
            "border, 1, 10, myBezier"
            "borderangle, 1, 8, myBezier"
            "fade, 1, 7, myBezier"
            "workspaces, 1, 6, myBezier"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          enable_swallow = true;
          swallow_regex = "^(Alacritty|kitty|ghostty)$";
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod,Return,exec,ghostty"
          "$mainMod SHIFT,Return,exec,ghostty"
          "$mainMod,q,killactive,"
          "$mainMod,v,togglefloating,"
          "$mainMod,d,exec,wofi --show run --term=ghostty --prompt=Run" # Application launcher
          "$mainMod SHIFT,d,exec,wofi-terminal-launcher" # Custom terminal commands
          "$mainMod,n,exec,cd ~/notes && ghostty -a foot-notes sh -c \"nvim ~/notes/$(date '+%Y-%m-%d').md\""
          "$mainMod,f,fullscreen,0"
          "$mainMod,p,pseudo,"
          "$mainMod,j,togglesplit,"
          "$mainMod,w,exec,firefox"
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"
          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
      };

      extraConfig = ''
        exec-once = swaybg -i $NIXOS_CONFIG_DIR/pics/wallpaper.png
        exec-once = ghostty --server
        exec-once = wlsunset -l -23 -L -46
        exec-once = dunst
        general {
          col.active_border = rgba(b6412dcc) rgba(ff4200cc) 45deg
          col.inactive_border = rgba(595959aa)
        }
      '';
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
