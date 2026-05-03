---
kind: task
slug: hunt-report-template
name: Produce Weekly Hunt Report Template
assignee: cti-hunter
project: supply-chain-monitoring
---

# Produce Weekly Hunt Report Template

## Objective

Create the standard template for CTI Hunter's weekly hunt report, and produce the first instance (Hunt Report 001) covering the period from the Axios case discovery (2026-03-31) to the first routine run date.

## Report Template

```markdown
# CTI Hunt Report [NNN]
Period: [YYYY-MM-DD] to [YYYY-MM-DD]
Analyst: CTI Hunter
Status: [Draft / Final]

## Hunt Summary
[3 sentences max: what was checked, what was found, overall threat level change this week]

## Threat Level
[Unchanged / Elevated / Reduced] — [one sentence justification]

## New Findings

| # | Finding | Type | Confidence | Source | Action |
|---|---------|------|------------|--------|--------|
| 1 | [description] | [IOC/Campaign/Actor Update] | [Confirmed/High/Plausible/Low] | [source URL] | [Watch list add / Escalate / Monitor] |

## Watch List Updates

### Added
- [IOC] — [reason] — [confidence]

### Removed
- [IOC] — [reason: expired / false positive / superseded]

### Upgraded Confidence
- [IOC]: [old grade] → [new grade] — [reason]

## Priority Actions This Week

1. [Action for MDR operators or virtual customers]
2. [Action]

## Open Threads

- [Thread description] → assigned to [Campaign Correlator / Threat Actor Profiler]

## Next Hunt
Scheduled: [date]
Focus areas: [any specific areas to prioritize based on this week's findings]
```

## Hunt Report 001 (First Instance)

After creating the template, produce Hunt Report 001 covering the Axios case period:
- Period: 2026-03-31 to first Monday routine run
- Summarize what is known from the Axios case public reporting
- State the current watch list status (v1 seeded from case)
- Identify what the first sweep will focus on
- Note the open research threads assigned to Campaign Correlator and Threat Actor Profiler

## Assigned To

CTI Hunter
