{ configs, pkgs, lib, ... }:
let
  setLimit = pkgs.writeShellScript "set-battery-limit" ''
    set -euo pipefail
    limit="$1"

    # Try common sysfs paths (vendor-dependent)
    for p in \
    /sys/class/power_supply/BAT*/charge_control_end_threshold \
    /sys/class/power_supply/BAT*/charge_control_stop_threshold \
    /sys/class/power_supply/BAT*/charge_stop_threshold \
    /sys/class/power_supply/BAT*/charge_control_end_threshold_percent \
    ; do
      for f in $p; do
        if [ -w "$f" ]; then
          echo "$limit" > "$f"
          exit 0
        fi
      done
    done

    echo "No writable battery threshold sysfs file found." >&2
    exit 1
    '';
in {
  systemd.services."battery-limit@" = {
    description = "Set battery charge limit to %i%%";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${setLimit} %i";
    };
  };

  # Default on boot: 60%
  systemd.services.battery-limit-boot = {
    description = "Set battery charge limit to 60% on boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${setLimit} 60";
    };
  };
}
