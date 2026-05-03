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
  - Maintain a living CTI program and curated knowledge vault for reusable MDR research.
---

MDR Frontier Research Lab is a research-oriented MDR company.

The company does not operate on real customer telemetry by default. It receives questions from virtual customers, frames the threat problem, simulates plausible attacker paths at a defensive level, designs detection coverage, and produces response guidance that an MDR team could use in a real advisory process.

The default workflow is hub-and-spoke with a CTI sub-team:

1. The Research Director receives the virtual customer question and defines the research contract.
2. The Principal Threat Intelligence Analyst builds the evidence pack and coordinates CTI Hunter, Threat Actor Profiler, and Campaign Correlator.
3. CTI specialists maintain watch lists, pivot across campaigns, and profile threat actors.
4. The Attack Simulation Lead models what attacks could have succeeded, with assumptions and confidence levels.
5. The Detection Engineering Lead maps the scenario to endpoint, cloud, identity, CI/CD, and package telemetry.
6. The Incident Response Strategist turns the research into containment, eradication, recovery, and customer-facing recommendations.
7. The Research Director reconciles disagreements, curates approved knowledge into the vault, and ships the final advisory.

For the first case, the lab studies the Axios npm supply-chain compromise as a template for answering questions about package compromise, maintainer account risk, CI/CD exposure, downstream detection, and customer response.
