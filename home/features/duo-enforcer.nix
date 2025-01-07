{ lib
, config
, pkgs
, inputs
, ...
}:
{
  config = {
    systemd.user.services.duo-enforcer = {
      Unit = {
        description = "Duo Enforcer Daemon";
      };
      serviceConfig = {
        ExecStart = "${inputs.duo-enforcer.packages.${pkgs.system}.duo-enforcer}/bin/duo-enforcer";
        Restart = "on-failure";
        After = "network-online.target";
      };
      Install = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
