# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = { # TODO: fix locales.
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false; # Xorg for sxhkd.
  };
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome.flashback.enableMetacity = true;
  services.xserver.windowManager.icewm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # sudoless docker. TODO: fix docker config.
    ];
    packages = with pkgs; [
      firefox # TODO: custom profile.
      # thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    (
      neovim.override {
        viAlias = true;
        vimAlias = true;
      }
    )
    wget

    # TODO: sql stuff
    # xterm # FIXME: comes by default with Gnome.
    aws-sam-cli awscli2
    bc
    blender
    cmake gnumake # make
    curl
    direnv nix-direnv # direnv stuff
    entr
    ffmpeg
    fzf
    gcc
    git gh # git and forges
    gnome.gnome-tweaks
    gnome.pomodoro
    gnomeExtensions.app-icons-taskbar
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vitals
    go gotools # Go is a tool for managing Go source code.
    htop-vim
    jdk # java
    kubectl kubectx kubernetes-helm minikube # k8s stuff
    losslesscut-bin
    lua luajit luarocks # lua
    man-pages man-pages-posix # man
    moreutils
    neofetch
    nixfmt # nix stuff
    nodePackages.pnpm nodejs-18_x # node stuff
    obs-studio
    python311 python311Packages.pip python311Packages.virtualenv # python stuff
    qbittorrent
    ripgrep
    rpi-imager
    shellcheck
    sxhkd xorg.xev xorg.xmodmap # sxhkd and friends
    tealdeer
    terraform
    tmux
    vlc
    vscode
    xsel 
    yt-dlp # FIXME: use unstable.
    zip unzip # zip and unzip

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  virtualisation.docker.enable = true; # TODO: fix docker config.

  nixpkgs.config.allowUnfree = true;

  documentation.man.generateCaches = true;
  # > By default as of NixOS 21.05,
  # > apropos, whatis and man -k do not find anything when run,
  # > because the man page index cache is not generated.
  # - https://nixos.wiki/wiki/Apropos

}
