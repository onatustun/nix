{ inputs, ... }:
{
  flake.modules = {
    nixos.xmpp =
      let
        domain = "xmpp.onatustun.com";
        mucDomain = "conference.${domain}";
        uploadDomain = "upload.${domain}";

        ssl = {
          cert = "/var/lib/acme/${domain}/fullchain.pem";
          key = "/var/lib/acme/${domain}/key.pem";
        };
      in
      {
        users.groups.certs.members = [
          "prosody"
          "caddy"
        ];

        security.acme = {
          acceptTerms = true;
          defaults.email = "mail@onatustun.com";

          certs.${domain} = {
            group = "certs";
            webroot = "/var/lib/acme/acme-challenge";
            postRun = "systemctl reload prosody.service";

            extraDomainNames = [
              mucDomain
              uploadDomain
            ];
          };
        };

        systemd.services."acme-${domain}" = {
          after = [ "caddy.service" ];
          wants = [ "caddy.service" ];
        };

        networking.firewall.allowedTCPPorts = [
          5222
          5223
          5269
          5281
          5298
          8010
        ];

        services = {
          caddy.virtualHosts = {
            "http://${domain}".extraConfig = ''
              handle /.well-known/acme-challenge/* {
                root * /var/lib/acme/acme-challenge
                file_server
              }
            '';

            "http://${mucDomain}".extraConfig = ''
              handle /.well-known/acme-challenge/* {
                root * /var/lib/acme/acme-challenge
                file_server
              }
            '';

            "http://${uploadDomain}".extraConfig = ''
              handle /.well-known/acme-challenge/* {
                root * /var/lib/acme/acme-challenge
                file_server
              }
            '';
          };

          prosody = {
            enable = true;
            admins = [ "admin@${domain}" ];
            inherit ssl;

            httpFileShare = {
              domain = uploadDomain;
              uploadFileSizeLimit = 100 * 1024 * 1024;
            };

            muc = [ { domain = mucDomain; } ];

            virtualHosts.${domain} = {
              enabled = true;
              inherit domain ssl;
            };

            modules = {
              roster = true;
              saslauth = true;
              tls = true;
              dialback = true;
              disco = true;
              carbons = true;
              pep = true;
              mam = true;
              ping = true;
              admin_adhoc = true;
            };

            allowRegistration = false;
          };
        };

        topology.self.services.prosody = {
          name = "Prosody XMPP";
          icon = inputs.self + "/assets/prosody.svg";
          info = domain;
        };
      };

    homeManager.gajim =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.gajim ];
      };
  };
}
