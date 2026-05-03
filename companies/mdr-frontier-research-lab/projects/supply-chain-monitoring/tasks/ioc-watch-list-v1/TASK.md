# Task: Build IOC Watch List v1

## Objective

Compile the initial IOC watch list from the Axios case and enrich each entry with context. This becomes the seed document for all future CTI Hunter runs.

## Deliverable

A structured watch list document (saved as an issue document in Paperclip) with:
- Each IOC categorized by type (domain, IP, hash, package, file path, registry key)
- Confidence grade (Confirmed / High / Plausible)
- Source attribution (which public report first cited this IOC)
- Expiry / review date (IOCs degrade over time; set a 90-day review for infrastructure IOCs)
- Associated threat actor hypothesis

## Initial IOCs from Axios Case

### Network Infrastructure
| IOC | Type | Confidence | Source | Notes |
|-----|------|------------|--------|-------|
| `sfrclak.com` | Domain | Confirmed | StepSecurity, Microsoft, Snyk | C2 domain |
| `142.11.206.73` | IP | Confirmed | Public reporting | C2 IP |
| `sfrclak.com:8000` | Host:Port | Confirmed | Multiple sources | C2 port |
| `/6202033` | URL Path | Confirmed | Multiple sources | C2 endpoint path |
| `packages.npm.org/product0` | POST path | High | StepSecurity | Platform routing POST body |
| `packages.npm.org/product1` | POST path | High | StepSecurity | Platform routing POST body |
| `packages.npm.org/product2` | POST path | High | StepSecurity | Platform routing POST body |

### Packages
| IOC | Type | Confidence | Source | Notes |
|-----|------|------------|--------|-------|
| `plain-crypto-js@4.2.1` | npm package | Confirmed | GHSA-fw8c-xr5c-95f9 | Injected malicious dependency |
| `axios@1.14.1` | npm package | Confirmed | GHSA-fw8c-xr5c-95f9 | Compromised upstream version |
| `axios@0.30.4` | npm package | Confirmed | GHSA-fw8c-xr5c-95f9 | Compromised upstream version |

### File Artifacts
| IOC | Type | Platform | Confidence | Notes |
|-----|------|----------|------------|-------|
| `/Library/Caches/com.apple.act.mond` | File path | macOS | High | Persistence artifact, Apple process name spoof |
| `/tmp/ld.py` | File path | Linux | High | Python dropper |
| `%TEMP%\6202033.vbs` | File path | Windows | High | Stager |
| `%TEMP%\6202033.ps1` | File path | Windows | High | PowerShell stager |
| `%PROGRAMDATA%\wt.exe` | File path | Windows | High | Persistent binary (renamed PowerShell or payload) |

### Registry / Persistence
| IOC | Type | Platform | Confidence | Notes |
|-----|------|----------|------------|-------|
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Run\MicrosoftUpdate` | Registry key | Windows | High | Persistence key name |

### Process Patterns
| IOC | Type | Confidence | Notes |
|-----|------|------------|-------|
| `node setup.js` spawning `osascript` | Process chain | High | macOS execution indicator |
| `node` → `/bin/sh` → `curl` → `python3 /tmp/ld.py` | Process chain | High | Linux execution chain |
| `node.exe` → `cmd.exe` / `cscript.exe` / `powershell.exe` → `.vbs` / `.ps1` | Process chain | High | Windows execution chain |

## Enrichment Steps

For each confirmed IOC:
1. Check VirusTotal for current detection rate and related files
2. Check AlienVault OTX for existing pulse tagging
3. Note if IOC is still active (infrastructure) or historical (package versions already pulled)

## Output Format

Save as an issue document with key `ioc-watch-list` in the Supply Chain Monitoring project issue.

## Assigned To

CTI Hunter
