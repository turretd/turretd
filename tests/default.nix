let
  # Pin nixpkgs, see pinning tutorial for more details
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  # Single source of truth for all tutorial constants
  database      = "postgres";
  schema        = "api";
  table         = "todos";
  username      = "authenticator";
  password      = "mysecretpassword";
  webRole       = "web_anon";
  postgrestPort = 3000;

  # NixOS module shared between server and client
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
  };

in pkgs.nixosTest ({
  # NixOS tests are run inside a virtual machine, and here we specify system of the machine.
  system = "x86_64-linux";

  nodes = {
    server = { config, pkgs, ... }: {
      imports = [ sharedModule ];

      networking.firewall.allowedTCPPorts = [ postgrestPort ];

      services.postgresql = {
        enable = true;

        initialScript = pkgs.writeText "initialScript.sql" ''
          create schema ${schema};

          create table ${schema}.${table} (
              id serial primary key,
              done boolean not null default false,
              task text not null,
              due timestamptz
          );

          insert into ${schema}.${table} (task) values ('finish tutorial 0'), ('pat self on back');

          create role ${webRole} nologin;
          grant usage on schema ${schema} to ${webRole};
          grant select on ${schema}.${table} to ${webRole};

          create role ${username} inherit login password '${password}';
          grant ${webRole} to ${username};
        '';
      };

      users = {
        mutableUsers = false;
        users = {
          # For ease of debugging the VM as the `root` user
          root.password = "";

          # Create a system user that matches the database user so that we
          # can use peer authentication.  The tutorial defines a password,
          # but it's not necessary.
          "${username}".isSystemUser = true;
        };
      };

      systemd.services.postgrest = {
        wantedBy = [ "multi-user.target" ];
        after = [ "postgresql.service" ];
        script =
          let
            configuration = pkgs.writeText "tutorial.conf" ''
                db-uri = "postgres://${username}:${password}@localhost:${toString config.services.postgresql.port}/${database}"
                db-schema = "${schema}"
                db-anon-role = "${username}"
            '';
          in "${pkgs.haskellPackages.postgrest}/bin/postgrest ${configuration}";
        serviceConfig.User = username;
      };
    };

    client = {
      imports = [ sharedModule ];
    };
  };

  # Disable linting for simpler debugging of the testScript
  skipLint = true;

  testScript = ''
    import json
    import sys

    start_all()

    server.wait_for_open_port(${toString postgrestPort})

    expected = [
        {"id": 1, "done": False, "task": "finish tutorial 0", "due": None},
        {"id": 2, "done": False, "task": "pat self on back", "due": None},
    ]

    actual = json.loads(
        client.succeed(
            "${pkgs.curl}/bin/curl http://server:${toString postgrestPort}/${table}"
        )
    )

    assert expected == actual, "table query returns expected content"
  '';
})