# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Gotta have my drivers
  nixpkgs.config.allowUnfree = true;

  # Overlays
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.devon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Define packages for devon
  users.users.devon.packages = with pkgs; [
    arandr
    awesome
    docker
    gcc10
    git
    gnumake
    neofetch
    neovim-nightly
    picom
    qutebrowser
    tmux
    tmuxinator
    zathura
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchFromGitHub {
        owner = "DevonMorris";
        repo = "st-deus";
        rev = "master";
        sha256 = "1mlbamhli8572xizcv31fvfm6d31wa7wmmm5k75b1ny6h1l33y1c";
       };
    }))
    (dmenu.overrideAttrs (oldAttrs: rec {
      src = fetchFromGitHub {
        owner = "DevonMorris";
        repo = "dmenu-devo";
        rev = "master";
        sha256 = "1zs5f05cs0i5przs8m5mz74l6cdh0ny59s5sgxnavgry5da61y0w";
       };
      patches = [];
    }))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    firefox
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
  ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "20.09";
}

