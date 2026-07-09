{ config, pkgs, unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.hostName = "angel";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";
  services.xserver.xkb.layout = "au";

  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  networking.firewall.allowedUDPPorts = [ 29716 42671 ];
  
  users.users.john = {
    isNormalUser = true;
    shell = pkgs.bashInteractive;
    description = "John";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # thunderbird
    ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    brave
    signal-desktop
    unstable.vscode
    git
    proton-vpn
    insomnia
    slack
    spotify
    direnv
    unstable.zed-editor
    nodejs_24
    zoom-us
    rustup
    vlc
    simplex-chat-desktop
    obs-studio
    sendme
    prismlauncher
    telegram-desktop
    unzip
    transmission_4-qt
    obsidian
    espanso-wayland
    rust-analyzer
    libreoffice
    fastfetch
    monero-gui
    termusic
    mpv
    unstable.yt-dlp
    spotdl   
  gst_all_1.gst-plugins-good
  gst_all_1.gst-plugins-bad
  gst_all_1.gst-plugins-ugly
  gst_all_1.gst-libav
  ffmpeg
  ];

  services.teamviewer.enable = false;

  services.jellyfin.enable = true;
  users.groups.media = {};
  users.users.jellyfin.extraGroups = [ "media" ];
  systemd.tmpfiles.rules = [
    "d /data/media       775 root media -"
    "d /data/media/Movies 775 root media -"
    "d /data/media/TV    775 root media -"
    "d /data/media/Music 775 root media -"
  ];
  
  
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
