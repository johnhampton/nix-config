# Power management overrides applied via pmset.
#
# We use pmset because nix-darwin's `power.sleep.*` module uses systemsetup
# without power-source selection, and our overrides need per-source control.
#
# Context: this machine has been hitting two macOS Tahoe (26.4.1) panic
# families during unattended periods:
#
#   1. WindowServer userspace_watchdog_timeout — a dark wake triggers
#      WindowServer's IOKit init path on a Thunderbolt-dock-attached system,
#      WindowServer's main thread stalls, and the watchdog panics the box.
#
#   2. launchd `initproc exited -- exit reason namespace 2 subcode 0xa` —
#      the Tahoe-26 launchd/libsystem fault family, correlated with rising
#      swap usage across long unattended uptimes.
#
# Power Nap and wake-on-network overrides target the dark-wake triggers:
#
#   pmset -a powernap 0
#     Disable Power Nap on both profiles. Removes scheduled maintenance
#     wakes (`com.apple.obc` battery-charging maintenance, periodic
#     Time Machine triggers, etc.) — one of these was the wake immediately
#     before the most recent WindowServer-watchdog panic.
#
#   pmset -c womp 0
#     Wake-on-network off on AC. Removes the MAGICWAKE kernel assertion
#     so network packets and Bonjour announcements can no longer initiate
#     a dark wake. Already off on battery by macOS default.
#
#   pmset -c sleep 0
#     Prevent automatic system sleep on power adapter while allowing the
#     display to sleep. Battery sleep is unchanged. Replaces the previous
#     30-minute AC sleep workaround for unattended uptime.
#     System Settings may need to be reopened to show the updated toggle.
#
# All other knobs are left at macOS defaults. The defaults observed on
# this machine (M2 Max MacBook Pro `Mac14,6`, macOS 26.4.1 / 25E253),
# captured from `pmset -g custom` before applying any overrides:
#
#   Battery Power:                     AC Power:
#     Sleep On Power Button   1          Sleep On Power Button   1
#     standby                 1          standby                 1
#     ttyskeepawake           1          ttyskeepawake           1
#     hibernatemode           3          hibernatemode           3
#     powernap                1          powernap                1   ← override → 0
#     hibernatefile           /var/vm/sleepimage
#     displaysleep            2          displaysleep           10
#     womp                    0          womp                    1   ← override → 0
#     networkoversleep        0          networkoversleep        0
#     sleep                   1          sleep                   0
#     lessbright              1
#     tcpkeepalive            1          tcpkeepalive            1
#     disksleep              10          disksleep              10
#
# This activation script runs on every `darwin-rebuild switch`. pmset is
# idempotent, so re-application is a no-op.

{ lib, ... }:
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "Applying pmset overrides..." >&2
    /usr/bin/pmset -a powernap 0
    /usr/bin/pmset -c womp 0
    /usr/bin/pmset -c sleep 0
  '';
}
