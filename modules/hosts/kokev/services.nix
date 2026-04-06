_: {
  flake.modules.nixos.kokev =
    {
      config,
      pkgs-stable,
      ...
    }:
    let
      ports = import ./_ports.nix { };
    in
    {
      sops = {
        secrets =
          let
            vaultwarden = ../../../secrets/${config.hostSettings.hostName}/vaultwarden.yaml;
            etebase = ../../../secrets/${config.hostSettings.hostName}/etebase.yaml;
          in
          {
            "vaultwarden.env" = {
              sopsFile = vaultwarden;
            };
            "etebase.secret" = {
              sopsFile = etebase;
              owner = "etebase-server";
            };
          };
      };
      services = {
        nullmailer = {
          enable = true;
          config = {
            remotes = "127.0.0.1 smtp";
            defaultdomain = "de";
          };
        };
        etebase-server = {
          enable = true;
          # Unstable is currently broken
          package = pkgs-stable.etebase-server;
          #port = ports.etebase;
          unixSocket = "/var/lib/etebase-server/etebase-server.sock";
          settings = {
            allowed_hosts.allowed_host1 = "etesync.kokev.de";
            global.secret_file = config.sops.secrets."etebase.secret".path;
            global.debug = false;
          };
        };
        ntfy-sh = {
          enable = true;
          settings = {
            listen-http = ":${toString ports.ntfy}";
            base-url = "https://ntfy.kokev.de";
          };
        };
        vaultwarden = {
          enable = true;
          environmentFile = config.sops.secrets."vaultwarden.env".path;
          config = {
            DOMAIN = "https://bitwarden.kokev.de";
            ROCKET_PORT = ports.vaultwarden;
            WEBSOCKET_ENABLED = true; # Enable WebSocket notifications
            SIGNUPS_ALLOWED = false;

            SMTP_HOST = "mail.kokev.de";
            SMTP_PORT = 25;
            SMTP_SECURITY = "starttls";

            SMTP_FROM = "bitwarden@kokev.de";
            SMTP_FROM_NAME = "Vaultwarden";
          };

        };
        prometheus.exporters = {
          node = {
            enable = true;
          };
        };
      };
      virtualisation.oci-containers.containers = {
        "joplin" = {
          # renovate: datasource=docker
          image = "docker.io/joplin/server:3.5.1@sha256:9f8666fb10abe385b3e674470557cfa072f4be1d4bcf069b10fb04cd844c1b0b";
          environment = {
            APP_BASE_URL = "https://joplin.kokev.de";
            APP_PORT = "22300";
            DB_CLIENT = "sqlite3";
            SQLITE_DATABASE = "/db/joplin.db";
          };
          ports = [
            "22300:22300/tcp"
          ];
          log-driver = "journald";
          volumes = [
            "/root/docker-container/joplin/data/sqlite:/db/:rw"
          ];
        };
        "mailserver" = {
          # renovate: datasource=docker
          image = "docker.io/mailserver/docker-mailserver:latest@sha256:af51b15dd3fc72153c0e90eb7692bb5e3a463212d87959a80fa7aa89b617d44a";
          environment = {
            "ACCOUNT_PROVISIONER" = "";
            "AMAVIS_LOGLEVEL" = "0";
            "CLAMAV_MESSAGE_SIZE_LIMIT" = "";
            "DEFAULT_RELAY_HOST" = "";
            "DMS_DEBUG" = "0";
            "DOVECOT_AUTH_BIND" = "";
            "DOVECOT_INET_PROTOCOLS" = "all";
            "DOVECOT_MAILBOX_FORMAT" = "maildir";
            "DOVECOT_PASS_FILTER" = "";
            "DOVECOT_TLS" = "";
            "DOVECOT_USER_FILTER" = "";
            "ENABLE_AMAVIS" = "0";
            "ENABLE_CLAMAV" = "0";
            "ENABLE_DNSBL" = "0";
            "ENABLE_FAIL2BAN" = "0";
            "ENABLE_FETCHMAIL" = "0";
            "ENABLE_LDAP" = "";
            "ENABLE_MANAGESIEVE" = "";
            "ENABLE_POP3" = "";
            "ENABLE_POSTFIX_VIRTUAL_TRANSPORT" = "";
            "ENABLE_POSTGREY" = "0";
            "ENABLE_QUOTAS" = "0";
            "ENABLE_SASLAUTHD" = "0";
            "ENABLE_SPAMASSASSIN" = "0";
            "ENABLE_SPAMASSASSIN_KAM" = "0";
            "ENABLE_SRS" = "0";
            "ENABLE_UPDATE_CHECK" = "1";
            "FAIL2BAN_BLOCKTYPE" = "drop";
            "FETCHMAIL_POLL" = "300";
            "LDAP_BIND_DN" = "";
            "LDAP_BIND_PW" = "";
            "LDAP_QUERY_FILTER_ALIAS" = "";
            "LDAP_QUERY_FILTER_DOMAIN" = "";
            "LDAP_QUERY_FILTER_GROUP" = "";
            "LDAP_QUERY_FILTER_USER" = "";
            "LDAP_SEARCH_BASE" = "";
            "LDAP_SERVER_HOST" = "";
            "LDAP_START_TLS" = "";
            "LOGROTATE_INTERVAL" = "weekly";
            "LOGWATCH_INTERVAL" = "";
            "LOGWATCH_RECIPIENT" = "";
            "LOGWATCH_SENDER" = "";
            "LOG_LEVEL" = "info";
            "MOVE_SPAM_TO_JUNK" = "1";
            "NETWORK_INTERFACE" = "";
            "ONE_DIR" = "1";
            "OVERRIDE_HOSTNAME" = "";
            "PERMIT_DOCKER" = "host";
            "PFLOGSUMM_RECIPIENT" = "";
            "PFLOGSUMM_SENDER" = "";
            "PFLOGSUMM_TRIGGER" = "";
            "POSTFIX_DAGENT" = "";
            "POSTFIX_INET_PROTOCOLS" = "all";
            "POSTFIX_MAILBOX_SIZE_LIMIT" = "";
            "POSTFIX_MESSAGE_SIZE_LIMIT" = "";
            "POSTGREY_AUTO_WHITELIST_CLIENTS" = "5";
            "POSTGREY_DELAY" = "300";
            "POSTGREY_MAX_AGE" = "35";
            "POSTGREY_TEXT" = "Delayed by Postgrey";
            "POSTMASTER_ADDRESS" = "";
            "POSTSCREEN_ACTION" = "enforce";
            "RELAY_HOST" = "";
            "RELAY_PASSWORD" = "";
            "RELAY_PORT" = "25";
            "RELAY_USER" = "";
            "REPORT_RECIPIENT" = "";
            "REPORT_SENDER" = "";
            "SASLAUTHD_LDAP_AUTH_METHOD" = "";
            "SASLAUTHD_LDAP_BIND_DN" = "";
            "SASLAUTHD_LDAP_FILTER" = "";
            "SASLAUTHD_LDAP_MECH" = "";
            "SASLAUTHD_LDAP_PASSWORD" = "";
            "SASLAUTHD_LDAP_PASSWORD_ATTR" = "";
            "SASLAUTHD_LDAP_SEARCH_BASE" = "";
            "SASLAUTHD_LDAP_SERVER" = "";
            "SASLAUTHD_LDAP_START_TLS" = "";
            "SASLAUTHD_LDAP_TLS_CACERT_DIR" = "";
            "SASLAUTHD_LDAP_TLS_CACERT_FILE" = "";
            "SASLAUTHD_LDAP_TLS_CHECK_PEER" = "";
            "SASLAUTHD_MECHANISMS" = "";
            "SASLAUTHD_MECH_OPTIONS" = "";
            "SASL_PASSWD" = "";
            "SA_KILL" = "6.31";
            "SPAM_SUBJECT" = "***SPAM*****";
            "SA_TAG" = "2.0";
            "SA_TAG2" = "6.31";
            "SMTP_ONLY" = "";
            "SPAMASSASSIN_SPAM_TO_INBOX" = "1";
            "SPOOF_PROTECTION" = "";
            "SRS_EXCLUDE_DOMAINS" = "";
            "SRS_SECRET" = "";
            "SRS_SENDER_CLASSES" = "envelope_sender";
            "SSL_ALT_CERT_PATH" = "";
            "SSL_ALT_KEY_PATH" = "";
            "SSL_CERT_PATH" = "";
            "SSL_KEY_PATH" = "";
            "SSL_TYPE" = "letsencrypt";
            "SUPERVISOR_LOGLEVEL" = "";
            "TLS_LEVEL" = "";
            "TZ" = "";
            "UPDATE_CHECK_INTERVAL" = "1d";
            "VIRUSMAILS_DELETE_DELAY" = "";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "/root/docker-container/mailserver/docker-data/dms/config:/tmp/docker-mailserver:rw"
            "/root/docker-container/mailserver/docker-data/dms/mail-data:/var/mail:rw"
            "/root/docker-container/mailserver/docker-data/dms/mail-logs:/var/log/mail:rw"
            "/root/docker-container/mailserver/docker-data/dms/mail-state:/var/mail-state:rw"
            "/var/lib/acme:/etc/letsencrypt/live:rw"
          ];
          ports = [
            "25:25/tcp"
            "465:465/tcp"
            "993:993/tcp"
          ];
          log-driver = "journald";
          extraOptions = [
            "--health-cmd=ss --listening --tcp | grep -P 'LISTEN.+:smtp' || exit 1"
            "--health-retries=5"
            "--health-timeout=3s"
            "--health-start-period=30s"
            "--hostname=mail.kokev.de"
          ];
        };
      };
    };
}
