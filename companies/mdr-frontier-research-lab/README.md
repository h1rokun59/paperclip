# MDR Frontier Research Lab

MDR Frontier Research Lab is an Agent Company for advanced MDR research. It is designed for a simulated customer environment: virtual customers ask how they should understand and respond to threats, and the company produces evidence-led guidance without relying on real customer data.

The lab's first starter project is the Axios npm supply-chain compromise case. The goal is to reason through what attacks could have worked, how an MDR organization could detect them, what response advice should be given, and how ongoing CTI monitoring should keep the research current.

## Workflow

The company runs as a hub-and-spoke research organization with a CTI sub-team.

The Research Director receives the customer question, defines the case scope, delegates to specialists, reconciles conflicting findings, curates approved knowledge into the knowledge vault, and delivers the final advisory. The Principal Threat Intelligence Analyst leads CTI Hunter, Threat Actor Profiler, and Campaign Correlator so the lab can continuously monitor related campaigns while case specialists handle simulation, detection, and response.

## Organization

| Agent | Title | Reports To | Primary Skills |
| --- | --- | --- | --- |
| research-director | Chief MDR Research Director | none | knowledge-vault, virtual-customer-mdr-triage, research-synthesis |
| threat-intelligence-analyst | Principal Threat Intelligence Analyst | research-director | evidence-led-threat-research, threat-actor-attribution, cti-hunt-reporting |
| cti-hunter | Continuous Threat Intelligence Hunter | threat-intelligence-analyst | continuous-cti-hunting, supply-chain-osint, cti-hunt-reporting |
| threat-actor-profiler | Threat Actor Attribution Specialist | threat-intelligence-analyst | threat-actor-attribution, campaign-correlation, supply-chain-osint |
| campaign-correlator | Cross-Campaign Correlation Specialist | threat-intelligence-analyst | campaign-correlation, supply-chain-osint, threat-actor-attribution |
| attack-simulation-lead | Defensive Attack Simulation Lead | research-director | defensive-attack-simulation, evidence-led-threat-research |
| detection-engineering-lead | Detection Engineering Lead | research-director | detection-engineering, endpoint-detection, cloud-detection |
| incident-response-strategist | Incident Response Strategist | research-director | incident-response-advisory, research-synthesis |

## Starter Project

`axios-supply-chain-case-lab` seeds the first MDR research case:

- Frame the virtual customer question.
- Compile an evidence timeline.
- Model feasible compromise and downstream impact paths.
- Design detection coverage.
- Produce a response advisory.

Additional starter projects:

- `supply-chain-monitoring`: ongoing weekly CTI hunt routine and IOC watch list.
- `threat-actor-campaign-research`: attribution, infrastructure, package publisher, RAT fingerprinting, and related campaign pivots.

## Getting Started

Import this company into Paperclip:

```sh
paperclipai company import ./companies/mdr-frontier-research-lab --target new --yes
```

For local Docker startup from this repository:

```sh
./scripts/mdr-up.sh
./scripts/mdr-up.sh --recreate-company
```

References:

- Agent Companies specification: https://agentcompanies.io/specification
- Paperclip: https://github.com/paperclipai/paperclip
