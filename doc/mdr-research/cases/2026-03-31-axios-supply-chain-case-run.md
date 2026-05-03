# MDR Research Case Run: Axios npm Supply Chain Compromise

Case ID: MDR-RLAB-2026-AXIOS-001
Run date: 2026-05-03
Status: Round 1 complete
Mode: Virtual customer research simulation

## 1. Virtual Customer Intake

Virtual customer: VC-FIN-01, a cloud-native fintech SaaS vendor.

Customer question:

> We heard about the Axios npm supply chain compromise. We use JavaScript services, GitHub Actions, macOS developer laptops, and AWS. Could this attack have worked against us? If yes, how would we detect it and what response is proportionate?

Assumed environment:

- GitHub-hosted and self-hosted CI runners.
- Node.js services with npm and pnpm.
- Some repositories use semver ranges such as `^1.14.0`.
- Dependabot/Renovate is enabled on several repositories.
- CI jobs have access to package registry tokens, GitHub tokens, deployment credentials, and AWS credentials in some workflows.
- Developer laptops are mostly macOS.
- Egress filtering is weak in CI; endpoint EDR exists on laptops.
- No real customer telemetry is available. This run uses public reporting plus synthetic environment assumptions.

## 2. Source Baseline

Public sources reviewed:

- GitHub Advisory Database, GHSA-fw8c-xr5c-95f9: https://github.com/advisories/GHSA-fw8c-xr5c-95f9
- Microsoft Threat Intelligence: https://www.microsoft.com/en-us/security/blog/2026/04/01/mitigating-the-axios-npm-supply-chain-compromise/
- Socket Research: https://socket.dev/blog/axios-npm-package-compromised
- StepSecurity: https://www.stepsecurity.io/blog/axios-compromised-on-npm-malicious-versions-drop-remote-access-trojan
- Snyk: https://snyk.io/blog/axios-npm-package-compromised-supply-chain-attack-delivers-cross-platform/
- GitLab Advisory mirror: https://advisories.gitlab.com/pkg/npm/axios/GHSA-fw8c-xr5c-95f9/

Baseline facts for simulation:

- Malicious Axios versions: `axios@1.14.1` and `axios@0.30.4`.
- Injected dependency: `plain-crypto-js@4.2.1`.
- Execution point: npm lifecycle `postinstall` in the injected dependency.
- Payload class: cross-platform RAT/dropper chain.
- Target platforms: macOS, Windows, Linux.
- Important observation: the trusted Axios runtime code did not need to be imported for execution; compromise happened during package installation.
- GitHub Advisory treats affected machines as fully compromised and recommends rotating secrets from a different machine.
- Common safe rollback versions cited in vendor reporting: `axios@1.14.0` for 1.x and `axios@0.30.3` for 0.x.

## 3. Research Organization Assignments

Incident Commander:

- Frame decision points for the virtual customer.
- Produce final risk classification and response recommendation.

Threat Intelligence Analyst:

- Confirm public facts, affected versions, IOCs, and attacker tradecraft.
- Separate high-confidence facts from vendor-specific attribution.

Attack Simulation Analyst:

- Model where the attack would execute in CI, developer endpoints, and build images.
- Identify conditions that make the attack fail.

Detection Engineer:

- Design dependency, process, network, file, cloud, and CI detections.
- Convert detections into portable logic that can become KQL/Sigma/YARA-like rules later.

Response Engineer:

- Decide containment, eradication, recovery, and secret rotation scope.
- Define proportional response tiers.

Research Scribe:

- Capture assumptions, evidence, decisions, and open questions.

## 4. Attack Hypothesis

Primary hypothesis:

An attacker compromised the Axios npm publishing path and introduced a malicious runtime dependency that executed during installation. A customer is exposed if a developer endpoint, CI runner, build image, or release pipeline resolved one of the malicious Axios versions and allowed package lifecycle scripts to run.

The attack can succeed without an application ever importing Axios at runtime. The decisive event is dependency installation.

## 5. Attack成立条件

The attack is considered executable when all or most of these are true:

1. The dependency resolver selects `axios@1.14.1` or `axios@0.30.4`.
2. `plain-crypto-js@4.2.1` is installed as a dependency.
3. npm/package manager lifecycle scripts are allowed.
4. The host can execute Node.js child processes.
5. The host has outbound access to the C2 infrastructure or any equivalent actor-controlled stage.
6. The host contains valuable secrets, signing material, cloud credentials, source code, release artifacts, or developer session tokens.

The attack is materially less likely to execute when:

- `npm ci` uses an unchanged lockfile pinned to a safe Axios version.
- Exact package versions and overrides force `axios@1.14.0` or `axios@0.30.3`.
- Lifecycle scripts are disabled with `ignore-scripts` for the relevant install path.
- CI egress blocks unapproved destinations.
- Build runners are ephemeral and contain no long-lived credentials.
- Dependency updates require human review and provenance checks.

## 6. Scenario Simulation Results

### Scenario A: CI job with semver range and fresh `npm install`

Assumption:

- `package.json` contains `axios: ^1.14.0`.
- The workflow runs fresh `npm install`.
- No lockfile or lockfile is regenerated.
- Scripts are enabled.
- CI has outbound internet and deployment secrets.

Assessment: High likelihood of execution.

Expected chain:

`npm install` resolves `axios@1.14.1`, installs `plain-crypto-js@4.2.1`, runs `postinstall`, spawns OS-specific commands, attempts network callout, and deploys a second-stage payload if reachable.

Business risk:

- CI secret exposure.
- Release artifact contamination.
- Repository token misuse.
- Cloud credential abuse.

Recommended response:

Treat runner and any produced artifacts as compromised. Rebuild from clean runner, revoke and rotate CI secrets, verify no malicious release artifact was published during the exposure window.

### Scenario B: CI job with `npm ci` and safe lockfile

Assumption:

- Lockfile already pins `axios@1.14.0`.
- CI uses `npm ci`.
- No dependency update occurred during the malicious publish window.

Assessment: Low likelihood of execution.

Residual risk:

- Other repos or branches may have regenerated lockfiles.
- Dependabot/Renovate PR branches may have resolved malicious versions even if main did not.

Recommended response:

Search all branches, PRs, package manager caches, and CI logs. If no malicious version or `plain-crypto-js` appears, no full compromise response is required for this path.

### Scenario C: macOS developer laptop with manual `npm install`

Assumption:

- Developer pulled a branch and ran `npm install` during the malicious window.
- EDR is present but egress is allowed.
- Developer has GitHub, npm, cloud, or SSH credentials locally.

Assessment: High severity if indicators are present.

Expected macOS indicators:

- `node setup.js` or npm lifecycle activity.
- `osascript`, `curl`, `chmod`, `/bin/zsh` child processes.
- File path resembling `/Library/Caches/com.apple.act.mond`.
- Network callout to actor infrastructure.

Recommended response:

Isolate endpoint, collect triage artifacts, rotate secrets from a different trusted machine, reimage if execution is confirmed or cannot be ruled out.

### Scenario D: Container build with `npm ci --ignore-scripts`

Assumption:

- Malicious version appears in lockfile.
- Lifecycle scripts are blocked.
- Build environment has network egress.

Assessment: Dependency contamination present, execution not demonstrated.

Recommended response:

Do not treat as full host compromise solely from lockfile presence. Remove malicious dependency, rebuild clean, validate no lifecycle execution occurred in logs. Escalate if scripts were enabled in any adjacent stage.

## 7. Detection Design

### 7.1 Dependency and Lockfile Detection

Detect:

- `axios@1.14.1`
- `axios@0.30.4`
- `plain-crypto-js`
- `plain-crypto-js@4.2.1`

Search locations:

- `package.json`
- `package-lock.json`
- `pnpm-lock.yaml`
- `yarn.lock`
- `bun.lockb` or Bun lock metadata where available
- CI build logs
- dependency bot branches and pull requests
- cached package manager directories
- built container layers

Important nuance:

The presence of `node_modules/plain-crypto-js` is suspicious even if the installed package metadata later appears clean. Some reporting describes post-execution anti-forensic behavior that may alter package metadata after install. For this case, directory presence and CI logs matter more than only `npm list` output.

### 7.2 Process Detection

Generic process pattern:

- package manager or `node` process runs install script.
- `node setup.js` spawns shell or script interpreter.
- shell launches `curl` or equivalent downloader.
- downloaded platform-specific payload is executed.

Linux pattern:

- `node` or package manager parent.
- child process `/bin/sh`.
- `curl` writes to `/tmp/ld.py`.
- detached `python3 /tmp/ld.py`.

macOS pattern:

- `node setup.js`.
- `osascript` or shell-launched AppleScript.
- `curl`.
- execution of a binary from `/Library/Caches/`.

Windows pattern:

- `node.exe setup.js`.
- `cmd.exe`, `cscript.exe`, or `powershell.exe`.
- temporary `.vbs` or `.ps1`.
- possible copy/rename of PowerShell to `%PROGRAMDATA%\wt.exe`.
- persistence under `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`.

### 7.3 Network Detection

High-confidence IOCs from public reports:

- Domain: `sfrclak.com`
- IP: `142.11.206.73`
- URL pattern: `http://sfrclak.com:8000/6202033`
- POST body patterns reported for platform routing:
  - `packages.npm.org/product0`
  - `packages.npm.org/product1`
  - `packages.npm.org/product2`

Detection recommendations:

- Search proxy, DNS, EDR network, firewall, and CI egress logs.
- Include historical lookup for the malicious publish window plus a buffer window.
- Treat no network hit as helpful but not decisive if logs are incomplete or egress was blocked before logging.

### 7.4 File and Persistence Detection

Candidate file indicators:

- macOS: `/Library/Caches/com.apple.act.mond`
- Linux: `/tmp/ld.py`
- Windows: `%TEMP%\6202033.vbs`, `%TEMP%\6202033.ps1`, `%PROGRAMDATA%\wt.exe`
- Windows persistence: `HKCU\Software\Microsoft\Windows\CurrentVersion\Run\MicrosoftUpdate`

Research caveat:

Absence of these files does not prove safety. Some artifacts may be deleted or not written if the chain failed at a previous step.

### 7.5 Cloud and Identity Detection

For any host with confirmed or plausible execution:

- Review GitHub token usage after the install event.
- Review npm token/package publishing activity.
- Review AWS/CloudTrail API calls from CI or developer identities.
- Review container registry pushes and release artifact signatures.
- Review suspicious source changes, workflow changes, secret reads, and deployment activity.

## 8. Response Decision Matrix

Tier 0: No exposure found

- No affected versions in lockfiles, branches, caches, CI logs, or endpoints.
- Action: document no exposure; add preventive controls.

Tier 1: Dependency exposure only

- Lockfile or branch contains malicious Axios version, but scripts were not run.
- Action: remove/rollback, rebuild clean, verify no install execution.

Tier 2: Install execution plausible

- Affected version was installed on CI or endpoint, but no C2 or payload evidence found.
- Action: rotate secrets exposed to that environment, rebuild runner/image, inspect artifacts, preserve logs.

Tier 3: Confirmed execution or C2 contact

- Process, network, file, or persistence evidence exists.
- Action: isolate, full compromise handling, rotate all secrets reachable from host, reimage/recreate runners, invalidate artifacts, hunt for post-compromise activity.

Tier 4: Confirmed credential misuse or artifact tampering

- Cloud/GitHub/npm misuse or suspicious release artifacts found.
- Action: incident response escalation, revoke credentials broadly, notify affected stakeholders, perform forensic timeline and product impact assessment.

## 9. Recommended Answer to Virtual Customer

Short answer:

This attack could have worked against VC-FIN-01 if any CI runner, developer laptop, or container build resolved `axios@1.14.1` or `axios@0.30.4` and allowed install scripts to run. The most dangerous path is fresh CI dependency installation with long-lived credentials or release signing/deployment capability.

Priority actions:

1. Search all repositories, branches, PRs, lockfiles, package caches, and CI logs for `axios@1.14.1`, `axios@0.30.4`, and `plain-crypto-js`.
2. Search endpoint and CI telemetry for npm install events during the exposure window.
3. Hunt network logs for `sfrclak.com`, `142.11.206.73`, port `8000`, and `/6202033`.
4. If install execution is plausible, rotate secrets exposed to that host or workflow from a trusted system.
5. Rebuild CI runners and release artifacts produced during suspected exposure.
6. Pin Axios to known safe versions and use package manager overrides.
7. Disable install scripts where feasible, especially in CI.
8. Restrict CI egress and remove long-lived credentials from build contexts.
9. Require provenance checks for dependency updates and package publishes.

Best research conclusion:

The highest-value MDR detection is not a single IOC. It is a combined analytic that joins dependency resolution, install-script execution, suspicious child process chains, and outbound C2 behavior. For real customers, this should be expressed as an exposure graph:

`repo -> dependency update -> build job/endpoint -> install script execution -> secrets present -> network/file evidence -> downstream artifact or cloud activity`

## 10. Detection Logic Backlog

Candidate analytics to implement in later rounds:

1. Lockfile contamination scanner for npm, pnpm, yarn, and bun.
2. CI log parser for malicious dependency installation and lifecycle script execution.
3. EDR process analytic: package manager or node spawning shell plus downloader during dependency install.
4. Network analytic for known C2 indicators and suspicious install-time egress.
5. Endpoint artifact scanner for OS-specific file and persistence paths.
6. Cloud blast-radius analyzer mapping CI workflows to secrets and deployment privileges.
7. Artifact integrity checker for releases produced during exposure windows.
8. Preventive control scorecard for dependency pinning, lockfile discipline, trusted publishing, and CI egress.

## 11. Paperclip Case Decomposition

Suggested Paperclip issues:

- AXIOS-001: Build authoritative incident fact base and confidence map.
- AXIOS-002: Model VC-FIN-01 dependency exposure scenarios.
- AXIOS-003: Design lockfile and dependency scanner.
- AXIOS-004: Design CI/process/network detection pack.
- AXIOS-005: Build response decision matrix and secret rotation scope.
- AXIOS-006: Generate virtual customer advisory report.
- AXIOS-007: Create synthetic telemetry set for Scenario A through D.

Suggested agents:

- Threat Intel Analyst
- Attack Simulation Analyst
- Detection Engineer
- Response Engineer
- Research Scribe
- Incident Commander

## 12. Open Questions for Round 2

- What exact package manager mix should VC-FIN-01 use in the simulation: npm only, pnpm, yarn, Bun, or mixed?
- Should the virtual customer have self-hosted runners with persistent workspaces?
- Should the simulated CI environment use long-lived AWS keys or OIDC-only federation?
- Should we generate synthetic logs for macOS, Linux CI, Windows developer endpoint, or all three?
- Should the next artifact be a customer-facing report, a detection engineering pack, or a Paperclip issue template?

