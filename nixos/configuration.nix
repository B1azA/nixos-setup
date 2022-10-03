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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.utf8";
    LC_IDENTIFICATION = "cs_CZ.utf8";
    LC_MEASUREMENT = "cs_CZ.utf8";
    LC_MONETARY = "cs_CZ.utf8";
    LC_NAME = "cs_CZ.utf8";
    LC_NUMERIC = "cs_CZ.utf8";
    LC_PAPER = "cs_CZ.utf8";
    LC_TELEPHONE = "cs_CZ.utf8";
    LC_TIME = "cs_CZ.utf8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
	enableXfwm = false;
        thunarPlugins = with pkgs.xfce; [
	  thunar-archive-plugin
        ];
      };
    };
    displayManager = {
      defaultSession = "xfce+i3";
      lightdm.enable = true;
      lightdm.greeters.mini = {
	enable = true;
	user = "b1aza";
	extraConfig = ''
	  [greeter-theme]
	  background-color = "#000000"
	  background-image = "/etc/nixos/wallpaper.png"
	  password-color = "#FFFFFF"
	  password-border-color = "#00897B"
	  window-color = "#363636"
	  border-color = "#00897B"
	  text-color = "#FFFFFF"
	'';
      };
      sddm.autoNumlock = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
	rofi
	nitrogen
        alacritty
	i3lock-color
	scrot
	xfce.xfce4-panel
	xfce.xfce4-i3-workspaces-plugin
	xfce.xfce4-panel-profiles
	xfce.xfce4-pulseaudio-plugin
	pavucontrol
      ];
    };
  };

  services.picom.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "cz";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "cz-lat2";

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
  users.users.b1aza = {
    isNormalUser = true;
    description = "Josef Blažek";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      chromium
      vscode
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # Tools
    vim
    wget
    htop
    zip
    unzip
    unrar
    gnome.file-roller
    killall
    nix-index
    gptfdisk

  # Development
    rustup
    gcc
    clang
    python3
    git
  
  # Customization
    lxappearance
    arc-theme
    arc-icon-theme
    phinger-cursors
    neofetch
  ];

  # Terminal start
  programs.bash.interactiveShellInit = ''
    neofetch
  '';

  fonts.fonts = with pkgs; [
    font-awesome
    fira-code
    fira
    roboto
    roboto-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "22.05"; # Did you read the comment?

}
