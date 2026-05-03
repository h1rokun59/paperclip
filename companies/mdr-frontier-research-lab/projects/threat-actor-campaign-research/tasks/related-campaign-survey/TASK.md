# Task: Related Campaign Survey

## Objective

Survey known npm and cross-ecosystem supply chain attacks from 2021 onward, assess whether any are attributable or linkable to the Axios attack actor, and produce a campaign timeline that places the Axios attack in context.

## Campaigns to Analyze

For each campaign below, research: timeline, IOCs, delivery mechanism, payload type, attribution, and any overlap with Axios case IOCs or TTPs.

### High Priority (Developer/CI targeting, similar TTP profile)
1. **Lazarus npm packages (2022–2025)**
   - Multiple packages mimicking job recruitment tools
   - Cross-platform RAT delivery, developer targeting
   - Sources: CrowdStrike, Mandiant, CISA, Phylum, Socket

2. **event-source-polyfill (2024)**
   - npm account takeover
   - Malicious postinstall script
   - C2 and payload details

3. **ua-parser-js (2021)**
   - npm account hijack
   - postinstall: cryptominer + RAT
   - Attribution never firmly established

### Medium Priority (Different vector or motive, but supply chain)
4. **xz-utils (2024)**
   - Long-term social engineering of maintainer
   - Different ecosystem (C/Linux), but comparable sophistication
   - Likely state actor; attribution ongoing

5. **PyPI RAT campaigns (2022–2025)**
   - Multiple waves of PyPI packages delivering RATs
   - Some linked to Lazarus Group (crypto/job-lure themed)
   - Check for `ld.py` pattern or similar Python dropper in PyPI campaigns

6. **Polyfill.io supply chain attack (2024)**
   - CDN-level compromise, JavaScript delivery
   - Different vector but same developer ecosystem targeting

### Lower Priority (Different motive, useful for contrast)
7. **colors.js / faker.js (2022)** — intentional sabotage, not APT
8. **node-ipc / peacenotwar (2022)** — activist, not APT
9. **left-pad (2016)** — accidental, not malicious

## For Each Campaign, Extract

- Date of discovery / exploitation window
- Affected packages and versions
- Delivery mechanism (account hijack, dependency confusion, maintainer compromise, etc.)
- Payload type (RAT, cryptominer, wiper, backdoor)
- C2 infrastructure (domains, IPs, protocols)
- File artifacts and persistence mechanisms
- Attribution (confirmed, high confidence, unknown)
- Overlap with Axios case: shared infrastructure, code patterns, publisher patterns, TTPs

## Output

- Campaign timeline table (2021–2026) with linkage assessment to Axios actor
- Confidence-graded connection graph: which campaigns are linked to the Axios actor?
- Summary of actor's evolution: is this a single persistent actor or multiple actors with shared tooling?

## Assigned To

Campaign Correlator
