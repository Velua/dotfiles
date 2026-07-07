{
  inputs,
  config,
  ...
}: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.keyFile = "/home/username/.config/sops/age/keys.txt";
    defaultSopsFile = secrets/secrets.yaml;

    secrets."cloudflared-creds" = {
      owner = "username";
      group = "users";
      mode = "0400";
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "dbf02928-f0e8-45ce-8734-12b8dbdb3b3c" = {
        credentialsFile = "${config.sops.secrets.cloudflared-creds.path}";
      };
    };
  };
}
