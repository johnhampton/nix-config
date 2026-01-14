{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.pspg
    pkgs.postgresql
  ];

  home.sessionVariables = {
    PSPG_CONF="${config.xdg.configHome}/pspg/pspg.conf";
  };

  xdg.configFile."pspg/pspg.conf".text = ''
    # Configuration file for pspg
    #
    custom_theme_name = onenord
  '';
  xdg.configFile."pspg/.pspg_theme_onenord".source = ./pspg_theme_onenord;

  home.file.".psqlrc".text = ''
    -- Use pspg as pager
    \setenv PAGER 'pspg'

    -- Recommended settings for psql
    \set QUIET 1
    \pset linestyle unicode
    \pset border 2
    \pset null ∅
    \unset QUIET
  '';

  home.file.".pg_service.conf".text = ''
    # PostgreSQL Connection Service File
    # Usage: psql service=<service_name>
    # Docs: https://www.postgresql.org/docs/current/libpq-pgservice.html

    [prod-account-service]
    host=/tmp/tan-ng-prod:us-west1:prod-master-database
    port=5432
    dbname=account-service
    user=account-service
    options=-c default_transaction_read_only=on

    [prod-account-service-write]
    host=/tmp/tan-ng-prod:us-west1:prod-master-database
    port=5432
    dbname=account-service
    user=account-service

    [prod-location-service-v2]
    host=/tmp/tan-ng-prod:us-west1:prod-master2-database
    port=5432
    dbname=location-service-v2
    user=location-service-v2
    options=-c default_transaction_read_only=on

    # Example: Local development database
    # [local_dev]
    # host=localhost
    # port=5432
    # dbname=myapp_development
    # user=postgres

    # Example: Remote production (read-only)
    # [prod_readonly]
    # host=db.example.com
    # port=5432
    # dbname=myapp_production
    # user=readonly_user
    # sslmode=require

    # Example: Docker container
    # [docker_pg]
    # host=localhost
    # port=5433
    # dbname=postgres
    # user=postgres
  '';
}

