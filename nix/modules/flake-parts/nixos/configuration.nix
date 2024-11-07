{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "actualism-app";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    # srid
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxPoqlThDrkR58pKnJgmeWPY9/wleReRbZ2MOZRyd''
    # Deploy key
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBdDeo43SrqSQbqm3BdT778KCz26G4xhINa8559gQs3K''
  ];
  system.stateVersion = "23.11";
}
