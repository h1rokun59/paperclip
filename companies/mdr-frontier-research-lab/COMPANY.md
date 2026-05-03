---
schema: agentcompanies/v1
kind: company
slug: mdr-frontier-research-lab
name: MDR Frontier Research Lab
description: Advanced MDR research company for simulating threat cases and producing defensible customer guidance.
version: 0.1.0
license: MIT
authors:
  - name: Hirok
tags:
  - mdr
  - threat-research
  - detection-engineering
  - incident-response
goals:
  - Answer virtual customer MDR questions with evidence, simulation, detection logic, and response guidance.
  - Study emerging and historical threats without using real customer data.
  - Convert each case into reusable detection, response, and research playbooks.
---

MDR Frontier Research Lab is a research-oriented MDR company.

The company does not operate on real customer telemetry by default. It receives questions from virtual customers, frames the threat problem, simulates plausible attacker paths at a defensive level, designs detection coverage, and produces response guidance that an MDR team could use in a real advisory process.

The default workflow is hub-and-spoke:

1. The Research Director receives the virtual customer question and defines the research contract.
2. The Threat Intelligence Analyst builds an evidence pack from trusted sources and known timelines.
3. The Attack Simulation Lead models what attacks could have succeeded, with assumptions and confidence levels.
4. The Detection Engineering Lead maps the scenario to telemetry, detections, and investigation pivots.
5. The Incident Response Strategist turns the research into containment, eradication, recovery, and customer-facing recommendations.
6. The Research Director reconciles disagreements and ships the final advisory.

For the first case, the lab studies the Axios npm supply-chain compromise as a template for answering questions about package compromise, maintainer account risk, CI/CD exposure, downstream detection, and customer response.
