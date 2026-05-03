# Skill: Campaign Correlation

## Purpose

Systematic methodology for connecting a known attack to related campaigns using infrastructure, code, publisher, and behavioral pivots. Produces a confidence-graded connection graph.

## Pivot Types

### Infrastructure Pivot
Starting from a domain or IP:
1. **Passive DNS**: what other domains have resolved to this IP? What IPs has this domain pointed to?
   - Tools: SecurityTrails, RiskIQ/PassiveTotal, DNSDB, Robtex, VirusTotal passive DNS
2. **WHOIS history**: registrant email, registrar, creation date pattern
   - Tools: DomainTools, WhoisXML API, SecurityTrails WHOIS history
3. **Certificate Transparency**: what TLS certs were issued for this domain or co-hosted domains?
   - Tools: crt.sh, Censys certificates
4. **Shodan/Censys**: what other services on this IP or subnet? Same port pattern?
   - Tools: Shodan, Censys, FOFA
5. **ASN**: is this IP on bulletproof or known-bad ASNs used by tracked actor clusters?

### Publisher/Account Pivot
Starting from a package publisher account:
1. All packages by this account across all ecosystems
2. Account creation date relative to malicious publish
3. Email domain or handle reuse across GitHub, npm, PyPI, Bitbucket
4. Commit history on GitHub: same email appears in commits?
5. Other accounts that co-maintained packages with this account

### Code Similarity Pivot
Starting from a malware sample or code pattern:
1. Search GitHub for unique strings, function names, or URL patterns from the sample
2. Search Malware Bazaar / Any.run / Hybrid Analysis for similar samples
3. Check VirusTotal similarity graph for related files
4. Look for the same C2 URL path pattern (e.g. `/NNNNNN` six-digit paths) in threat intel reports
5. Cross-reference RAT family with known malware families: QuasarRAT, AsyncRAT, Dacls, POOLRAT, NimRAT, MeshAgent

### TTP Pivot
Starting from attack technique patterns:
- `postinstall` lifecycle script → remote download → platform detection → OS-specific dropper
- This is a documented MITRE technique: T1195.001 (Supply Chain Compromise: Compromise Software Dependencies and Development Tools)
- Combined with T1059 (Command and Scripting Interpreter) and T1071 (Application Layer Protocol)
- Search for other campaigns using the exact same execution chain in public reporting

## Confidence Grading

| Grade | Criteria |
|-------|---------|
| Confirmed | Direct evidence: same infrastructure, same code, or same account confirmed by multiple independent sources |
| High | Strong overlap in 2+ pivot dimensions, consistent with known actor TTP |
| Plausible | Single-dimension overlap, could be coincidence but warrants tracking |
| Low Signal | Weak pattern match, worth noting but not actionable alone |

## Connection Graph Format

```
[Campaign A] --[shared IP: 142.11.206.73]--(High)--> [Campaign B]
[Campaign A] --[same npm publisher account]--(Confirmed)--> [Package X]
[Campaign B] --[code similarity: ld.py dropper pattern]--(Plausible)--> [Campaign C]
```

## Known npm Supply Chain Campaign Reference Set

Use these as comparison points when correlating new campaigns:

| Campaign | Year | Vector | Actor Attribution | Key IOCs |
|----------|------|--------|------------------|----------|
| ua-parser-js | 2021 | npm account hijack | Unknown financially motivated | postinstall, coinminer + RAT |
| node-ipc / peacenotwar | 2022 | Intentional sabotage | RIAEvangelist (known dev) | wiper, anti-Russia |
| Lazarus npm packages | 2022-2025 | Fake job offer repos | Lazarus Group (DPRK) | interview-themed packages, cross-platform RAT |
| event-source-polyfill | 2024 | npm account takeover | Unknown | postinstall downloader |
| xz-utils | 2024 | Long-term contributor social engineering | Unknown (likely state actor) | liblzma backdoor, SSH target |
| axios | 2026 | npm publish compromise | TBD — under research | plain-crypto-js, sfrclak.com, cross-platform RAT |
