# Skill: Threat Actor Attribution

## Purpose

Structured methodology for attributing cyberattacks to known or new threat actors. Produces a confidence-graded attribution assessment, not a definitive claim. All attribution is probabilistic and subject to revision as new evidence emerges.

## Attribution Dimensions

Good attribution uses multiple independent evidence dimensions. A single IOC match is never sufficient for confident attribution.

### 1. Technical Indicators
- Malware code overlap: same codebase, shared libraries, similar obfuscation
- Infrastructure patterns: same ASNs, registrars, IP ranges, hosting providers
- C2 protocol and path patterns
- File artifact naming conventions
- Persistence mechanism choices (registry keys, LaunchAgents, cron patterns)

### 2. Operational Patterns (TTPs)
- Target selection: who gets attacked and why
- Delivery method: phishing, supply chain, watering hole, etc.
- Execution chain: how the malware runs after delivery
- Collection objectives: credentials, source code, financial systems, data exfiltration
- Timing: operating hours correlate with actor timezone

### 3. Behavioral Patterns
- Time-of-day activity (correlates with actor's timezone)
- Victim geography and sector
- Operational tempo: continuous campaigns vs. episodic attacks
- Response to detection: do they retool quickly or go quiet?

## APT Group Reference: Developer-Targeting Actors

### Lazarus Group (DPRK)
- Attribution: US CISA, FBI, South Korean NIS, multiple private vendors
- Relevant TTPs: npm supply chain packages, fake job offers, developer targeting, cross-platform RAT, macOS targeting
- Known npm campaigns: multiple packages mimicking job recruitment tools (2022–2025)
- Typical C2: custom HTTP/HTTPS C2, sometimes using legitimate services as dead drops
- Key characteristic: targets cryptocurrency, DeFi, financial sector developers for financial theft
- MITRE Group ID: G0032

### APT41 (China)
- Relevant TTPs: supply chain compromise (CCleaner, SolarWinds-adjacent), developer tooling
- Less likely for npm-specific attacks but has broad software supply chain history
- MITRE Group ID: G0096

### UNC4736 / TraderTraitor (DPRK-adjacent)
- Specifically targets crypto/DeFi developers with malicious repos and packages
- Overlaps with Lazarus targeting profile

### Unknown Financially Motivated Actors
- ua-parser-js 2021 — account hijack for cryptominer + RAT, attribution unclear
- Organized crime groups using supply chain as initial access for ransomware

## Attribution Assessment Template

```
## Threat Actor Attribution Assessment

Case: [case name]
Date: [date]
Analyst: [agent name]

### Evidence Summary
[List key evidence items with confidence grades]

### Attribution Hypotheses

**Hypothesis 1: [Actor Name]**
- Supporting: [evidence]
- Against: [counter-evidence]
- Confidence: [High/Medium/Low/Insufficient]

**Hypothesis 2: [Actor Name or "Unknown actor with similar profile"]**
- Supporting: [evidence]
- Against: [counter-evidence]
- Confidence: [High/Medium/Low/Insufficient]

### Assessment
[Most probable attribution with stated confidence and key caveats]

### What Would Change This Assessment
[Specific evidence that would upgrade, downgrade, or shift attribution]
```

## Important Caveats

- Never assert attribution with certainty from a single campaign analysis
- Threat actors intentionally use false flags (infrastructure from different regions, copied code)
- Infrastructure reuse can be due to bulletproof hosting used by multiple unrelated actors
- Code similarity can reflect shared toolkits/crime-as-a-service, not the same team
- Always state what evidence is missing and what would change the assessment
