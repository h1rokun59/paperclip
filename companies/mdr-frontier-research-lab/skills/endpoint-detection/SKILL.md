# Skill: Endpoint Detection

## Purpose

Design detection logic for host-based telemetry across Linux, macOS, and Windows. Focus on process execution, file system activity, persistence mechanisms, and lateral movement patterns — particularly in the context of supply chain and developer-toolchain attacks.

## Telemetry Sources by Platform

### Linux
- **Process**: `auditd` (execve, fork), EDR process telemetry, `/proc` snapshots
- **File**: `inotify`-based monitoring, EDR file events, `/tmp` write + execute patterns
- **Network**: `netfilter` / `iptables` logs, EDR network events, DNS resolver logs
- **Persistence**: cron (`/etc/cron*`, `/var/spool/cron`), systemd units, `~/.bashrc` / `~/.profile`, `/etc/profile.d/`
- **Package manager**: `dpkg`/`rpm` install logs, npm/pip install stdout captured in CI logs

### macOS
- **Process**: Endpoint Security Framework (ESF) events, EDR process telemetry, `oslog`
- **File**: ESF file events, spotlight metadata, `/Library/` write events
- **Network**: `pf` firewall logs, EDR network events, DNS logs
- **Persistence**: LaunchAgents (`~/Library/LaunchAgents/`), LaunchDaemons (`/Library/LaunchDaemons/`), Login Items, `/Library/Caches/` executable writes
- **Apple-specific**: `osascript` execution, `xattr` quarantine removal, Gatekeeper bypasses
- **Package manager**: `npm`, `pip`, `brew` install events captured via EDR or terminal logging

### Windows
- **Process**: Sysmon Event ID 1, WEL 4688, EDR process telemetry
- **File**: Sysmon Event ID 11, EDR file events
- **Network**: Sysmon Event ID 3, DNS Event ID 22, EDR network events, firewall logs
- **Persistence**: Registry Run keys (HKCU/HKLM), Scheduled Tasks (Event ID 4698), Startup folder, Services
- **Script execution**: PowerShell Script Block Logging (Event ID 4104), `cscript`/`wscript` execution, `.vbs`/`.ps1` spawned from `node.exe`
- **Package manager**: npm/pip install events, `node.exe` spawning `cmd.exe` or `powershell.exe`

## Detection Patterns: Supply Chain / Developer Toolchain

### Pattern 1: Package Manager Spawning Shell + Downloader
Applies to all platforms. High-fidelity signal when combined with install-time context.

```
parent: npm / node / pip / gem / cargo
child:  /bin/sh | cmd.exe | powershell.exe
grandchild: curl | wget | certutil | bitsadmin | Invoke-WebRequest
```

Tuning note: filter on `npm install` / `pip install` invocations specifically; `node` spawning shells at other times is common in dev tooling.

### Pattern 2: Install-time Executable Write to Suspicious Path
```
process: node (setup.js / install.js)
file_write:
  linux:   /tmp/*.py | /tmp/*.sh
  macOS:   /Library/Caches/com.apple.*  (non-Apple binary)
  windows: %TEMP%\*.vbs | %TEMP%\*.ps1 | %PROGRAMDATA%\*.exe
```

### Pattern 3: Persistence Registration After Install
```
windows: reg.exe / powershell SetValue → HKCU\...\Run\*
macOS:   file_write → ~/Library/LaunchAgents/*.plist
linux:   file_write → ~/.bashrc | /etc/cron.d/* | systemd unit
```

### Pattern 4: Post-Install Network Callout
```
parent: node | python | sh | powershell
dest:   non-registry, non-CDN domain on non-standard port
timing: within seconds of npm/pip install completing
```

## Query Pseudo-Logic Examples

### KQL (endpoint process chain — supply chain install)
```kql
DeviceProcessEvents
| where InitiatingProcessFileName in ("node.exe", "npm.cmd", "pip.exe")
| where FileName in ("cmd.exe", "powershell.exe", "sh", "bash", "curl", "wget")
| where Timestamp between (installWindowStart .. installWindowStart + 5m)
```

### Sigma (macOS suspicious cache write)
```yaml
detection:
  selection:
    EventID: file_create
    TargetFilename|startswith: '/Library/Caches/'
    Image|endswith: 'node'
  condition: selection
```

## Cross-Platform Consistency Rule

When designing detection for a supply chain attack, always cover all three platforms unless the threat is confirmed platform-specific. The Axios RAT targeted macOS, Linux, and Windows — a macOS-only or Windows-only detection set leaves real exposure.
