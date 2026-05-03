# Skill: Continuous CTI Hunting

## Purpose

Systematic, repeatable methodology for ongoing threat intelligence collection focused on tracked threat actors and supply chain attack patterns.

## Hunt Cycle

Each hunt run follows this sequence:

### 1. Watch List Sweep
For each tracked IOC:
- Check VirusTotal for new detections or related files
- Check Shodan/Censys for infrastructure changes
- Check passive DNS for new domain-IP associations
- Search GitHub, pastebin, and code search for new IOC mentions

### 2. Advisory Feed Review
Sources to check every week:
- GitHub Advisory Database: `https://github.com/advisories?query=type:reviewed`
- npm security advisories: `https://www.npmjs.com/advisories`
- OSV.dev: `https://osv.dev/list`
- Socket Research blog: `https://socket.dev/blog`
- Phylum Research: `https://blog.phylum.io`
- Checkmarx SCS: public findings
- Snyk blog: `https://snyk.io/blog`
- StepSecurity blog: `https://www.stepsecurity.io/blog`

### 3. Registry Sweep
Search npm for:
- New packages with `postinstall` scripts that download and execute remote content
- Packages with names that spoof popular libraries (`crypto`, `axios`, `lodash`, `express` typosquats)
- Packages published by tracked publisher accounts
- Low-download packages with suspicious metadata (short description, no README, recent creation)

### 4. Threat Actor News
Check vendor threat intelligence blogs:
- Microsoft MSTIC: `https://www.microsoft.com/en-us/security/blog/`
- Mandiant/Google TAG
- CrowdStrike Intelligence
- Recorded Future Insikt Group
- Sekoia TDR
- CISA alerts: `https://www.cisa.gov/news-events/alerts`

### 5. IOC Enrichment
For any new IOC discovered:
- Grade confidence: Confirmed / High / Plausible / Low Signal
- Check for connection to existing tracked IOCs
- Assess whether it expands, contradicts, or confirms current actor profile
- Decide: add to watch list, escalate immediately, or park for future run

## Triage Criteria

Escalate immediately (do not wait for weekly report):
- New malicious package with confirmed execution that overlaps tracked actor TTPs
- C2 infrastructure reactivation or new domain registered by tracked actor
- Public PoC or exploit for tracked actor's delivery mechanism
- New CISA / government advisory naming tracked actor or their tooling

Normal weekly report:
- New passive DNS associations
- New related package discoveries (confidence < High)
- Vendor blog posts with partial overlap
- Watch list updates that don't require immediate customer action
