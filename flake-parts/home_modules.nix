{
  inputs,
  self,
  ...
}: {
  flake.homeModules = {
    global-keybind = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.global-keybind;
    in {
      options = {
        global-keybind = {
          enable = lib.mkEnableOption "Enable global keybind";
          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.system}.global-keybind-cli;
          };
          device = lib.mkOption {
            type = lib.types.string;
            example = "/dev/input/event0";
          };
          key_to_press = lib.mkOption {
            type = lib.types.ints.u16;
            example = 275;
          };
          key_to_send = lib.mkOption {
            type = lib.types.string;
            example = "F12";
          };
          display = lib.mkOption {
            type = lib.types.nullOr lib.types.string;
            example = ":1";
            default = null;
          };
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.user.services.global-keybind = {
          Unit = {
            Description = "Global keybind";
          };
          Install = {
            WantedBy = ["graphical-session.target"];
          };
          Service = {
            ExecStart = "${cfg.package}/bin/global-keybind-cli start --device ${cfg.device} --key-to-press ${toString cfg.key_to_press} --key-to-send ${cfg.key_to_send}";
            Restart = "on-failure";
            Environment = lib.mkIf (cfg.display != null) [
              "DISPLAY=${cfg.display}"
            ];
          };
        };
      };
    };
  };
}
