{ inputs, self, ... }:
{
  systems = [ "x86_64-linux" "aarch64-linux" ];
  imports = [ inputs.nixos-unified.flakeModules.default ];

  flake.nixosConfigurations."actualism-app" =
    self.nixos-unified.lib.mkLinuxSystem
      { home-manager = false; }
      {
        nixos-unified.sshTarget = "root@5.161.237.23";
        nixpkgs.hostPlatform = "x86_64-linux";
        imports = [
          ./configuration.nix
          ./app.nix
          # https://github.com/srid/nixos-unified/issues/89
          ({ pkgs, ... }: { environment.systemPackages = [ pkgs.git ]; })
        ];
      };
}
