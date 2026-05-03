# Task: APT Attribution Assessment

## Objective

Produce a structured, confidence-graded attribution assessment for the Axios npm supply chain attack, evaluating the most probable threat actor hypotheses against available evidence.

## Input (from other research tasks)

This task depends on outputs from:
- npm Publisher Pivot (publisher account profile)
- C2 Infrastructure Pivot (infrastructure relationship map)
- RAT Codebase Fingerprinting (malware family classification)
- Related Campaign Survey (campaign timeline and overlaps)

## Hypotheses to Evaluate

### H1: Lazarus Group / TraderTraitor (DPRK)
Supporting indicators to check:
- npm developer targeting is a well-documented Lazarus TTP (2022–2025 campaigns)
- Cross-platform RAT with macOS focus is consistent with Lazarus tooling (Dacls, POOLRAT, NimRAT)
- macOS persistence in `/Library/Caches/` mimicking Apple process names is a known Lazarus pattern
- Targeting of CI/CD and developer credentials aligns with DPRK financial objectives
- Axios is used heavily in DeFi/crypto front-ends, which are priority Lazarus targets

Counter-indicators to check:
- Infrastructure hosting and registration style
- Operational timing (correlates with what timezone?)
- Presence or absence of OPSEC mistakes typical of Lazarus

### H2: UNC4736 / AppleJeus Cluster (DPRK-adjacent, crypto focus)
- Specifically targets crypto industry developers
- Has used npm packages in past campaigns
- Overlapping with Lazarus Group in tooling and targeting

### H3: Unknown financially motivated cybercrime actor
- Mass credential harvest for resale
- No state sponsorship required to explain TTPs
- Account takeover of axios maintainer would fit opportunistic criminal profile

### H4: New/unknown state-adjacent actor
- Sophisticated enough for supply chain but no clear link to known clusters
- Possibility of a new entrant or an actor that hasn't been publicly attributed before

## Assessment Framework

For each hypothesis, score on:
1. TTP match (0–3)
2. Infrastructure pattern match (0–3)
3. Targeting profile match (0–3)
4. Tooling/malware family match (0–3)
5. Historical campaign overlap (0–3)

Total score guides confidence: 12–15 = High, 8–11 = Medium, 4–7 = Low, <4 = Insufficient

## Output

Use the Attribution Assessment Template from the `threat-actor-attribution` skill.

Deliver:
- Structured assessment with evidence table
- Most probable attribution with stated confidence
- Key evidence gaps that would change the assessment
- MITRE ATT&CK Group ID if a known group is assessed as probable

## Assigned To

Threat Actor Profiler
