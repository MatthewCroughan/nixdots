#  ________         __                                 __         
# |  |  |  |.-----.|  |.----.-----.--------.-----.    |  |_.-----.
# |  |  |  ||  -__||  ||  __|  _  |        |  -__|    |   _|  _  |
# |________||_____||__||____|_____|__|__|__|_____|    |____|_____|
#                                                               
#                          ___ __ __                              
# .--------.--.--.       .'  _|__|  |.-----.-----.                
# |        |  |  |     __|   _|  |  ||  -__|__ --|                
# |__|__|__|___  |    |__|__| |__|__||_____|_____|                
#          |_____|                                                

{ config, pkgs, ... }:
let
  # Import the global variables file
  global = import ./global-var.nix;
in {
  # The version this configuration was made in
  home-manager.users.user.home.stateVersion = "22.11";
  system.stateVersion = "22.11"; 

  imports =
    [
      # Import home manager https://github.com/nix-community/home-manager
      <home-manager/nixos>
      ./hardware-configuration.nix
      ./terminal/zsh/zsh.nix
      ./terminal/nvim/nvim.nix
      ./terminal/unconfigured.nix
      ./graphical/alacritty/alacritty.nix
      ./graphical/tk-themes/gtk/gtk.nix
      ./graphical/tk-themes/qt/qt.nix
      ./graphical/tk-themes/theme.nix
      ./graphical/i3/i3.nix
      ./graphical/picom/picom.nix
      ./graphical/fonts/fonts.nix
      ./graphical/virt-manager/virt-manager.nix
      ./graphical/openrgb/openrgb.nix
      ./graphical/unconfigured.nix
      ./misc/hosts/hosts.nix
      ./misc/udev/udev.nix
      ./misc/default-programs/default-programs.nix
      ./services/pipewire/pipewire.nix
      ./services/xorg/xorg.nix
      ./services/polkit/polkit.nix
      ./lanuage-support/keyboard/Japanese/mozc.nix
    ];

  # Enable boot loader and set boot mount point
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set time zone
  time.timeZone = "America/Chicago";

  # Set default locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Set extra locale settings
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };  

  # Create user with the name specified in the global-var file with Zsh shell, additional groups and no packages
  users.users.${global.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [];
  };

  # Allow installing packages that are not free
  nixpkgs.config.allowUnfree = true;

  nix.settings.auto-optimise-store = true;
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
