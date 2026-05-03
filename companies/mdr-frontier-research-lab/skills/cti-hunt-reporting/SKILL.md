# Skill: CTI Hunt Reporting

## Purpose

Produce structured, actionable threat intelligence reports from hunt runs. Reports must be useful to MDR operators and virtual customers, not just researchers.

## Report Types

### Weekly Hunt Report
Produced by CTI Hunter after each routine run.

Structure:
1. **Hunt Summary** (3 sentences max): what was checked, what was found, overall threat level change
2. **New Findings** (graded list): each finding with confidence grade and source
3. **Watch List Changes**: additions, removals, confidence upgrades/downgrades
4. **Priority Actions**: what MDR customers should do in the next 7 days
5. **Open Threads**: items handed off to Threat Actor Profiler or Campaign Correlator

### Threat Actor Profile Report
Produced by Threat Actor Profiler when a new actor profile is complete or significantly updated.

Structure:
1. **Actor Summary**: known or suspected group, confidence, primary motivation
2. **Attribution Evidence**: structured evidence table with grades
3. **Campaign Timeline**: ordered list of attributed or likely-attributed campaigns
4. **TTP Summary**: MITRE ATT&CK techniques observed
5. **Infrastructure Profile**: known infrastructure patterns
6. **Targeting Profile**: who they target and why
7. **Watch Items**: specific IOCs and behavioral patterns to track going forward

### Campaign Correlation Report
Produced by Campaign Correlator when a pivot thread is complete.

Structure:
1. **Seed Campaign**: starting point
2. **Pivot Graph**: connections found with confidence grades
3. **New IOCs**: ready for watch list ingestion
4. **Actor Overlap Assessment**: same actor / same toolkit / shared infrastructure / unrelated
5. **Recommended Next Pivots**: what to follow up on

## Evidence Grading Standard

| Grade | Label | Criteria |
|-------|-------|---------|
| 1 | Confirmed | Verified by multiple independent sources or direct technical analysis |
| 2 | High Confidence | Strong single source or consistent pattern across multiple data points |
| 3 | Plausible | Reasonable inference from available evidence, alternative explanations possible |
| 4 | Low Signal | Weak pattern, worth noting but not actionable alone |
| 5 | Speculation | Hypothesis only, no supporting technical evidence yet |

## Actionability Test

Before finalizing any report, ask:
- Does this report tell an MDR operator what to look for right now?
- Does it tell a customer what to do differently this week?
- Does it tell another research agent where to start next?

If the answer to all three is no, the report is not done.
