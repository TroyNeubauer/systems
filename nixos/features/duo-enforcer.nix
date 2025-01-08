{ lib
, config
, pkgs
, inputs
, ...
}:
{
  options.services.duo-enforcer = {
    enable = lib.mkEnableOption "Enable the Duo Enforcer service.";
  };

  config = lib.mkIf config.services.duo-enforcer.enable {
    systemd.services.duo-enforcer = {
      description = "Duo Enforcer Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${inputs.duo-enforcer.packages.${pkgs.system}.duo-enforcer}/bin/duo-enforcer";
        Restart = "always";
        RestartSec = 5;
      };
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
