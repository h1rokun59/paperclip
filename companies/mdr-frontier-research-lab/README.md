# MDR Frontier Research Lab

MDR Frontier Research Lab is an Agent Company for advanced MDR research. It is designed for a simulated customer environment: virtual customers ask how they should understand and respond to threats, and the company produces evidence-led guidance without relying on real customer data.

The lab's first starter project is the Axios npm supply-chain compromise case. The goal is to reason through what attacks could have worked, how an MDR organization could detect them, and what response advice should be given to affected or exposed customers.

## Workflow

The company runs as a hub-and-spoke research organization.

The Research Director receives the customer question, defines the case scope, delegates to specialists, reconciles conflicting findings, and delivers the final advisory. Specialist agents work in parallel where possible and leave durable case notes, assumptions, confidence levels, and next actions.

## Organization

| Agent | Title | Reports To | Primary Skills |
| --- | --- | --- | --- |
| research-director | Chief MDR Research Director | none | virtual-customer-mdr-triage, research-synthesis, incident-response-advisory |
| threat-intelligence-analyst | Threat Intelligence Analyst | research-director | evidence-led-threat-research, virtual-customer-mdr-triage |
| attack-simulation-lead | Defensive Attack Simulation Lead | research-director | defensive-attack-simulation, evidence-led-threat-research |
| detection-engineering-lead | Detection Engineering Lead | research-director | detection-engineering, defensive-attack-simulation |
| incident-response-strategist | Incident Response Strategist | research-director | incident-response-advisory, research-synthesis |

## Starter Project

`axios-supply-chain-case-lab` seeds the first MDR research case:

- Frame the virtual customer question.
- Compile an evidence timeline.
- Model feasible compromise and downstream impact paths.
- Design detection coverage.
- Produce a response advisory.

## Getting Started

Import this company into Paperclip:

```sh
paperclipai company import ./companies/mdr-frontier-research-lab --target new --yes
```

References:

- Agent Companies specification: https://agentcompanies.io/specification
- Paperclip: https://github.com/paperclipai/paperclip
