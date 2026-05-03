---
kind: project
slug: threat-actor-campaign-research
name: Threat Actor Campaign Research
description: Profile and track the actor or actor cluster behind the Axios npm supply-chain attack.
owner: threat-actor-profiler
tags:
  - threat-actor
  - attribution
  - campaign-research
---

# Threat Actor Campaign Research

## Goal

Identify, profile, and track the threat actor behind the Axios npm supply chain attack (2026-03-31). Pivot from known IOCs to discover related campaigns, establish attribution confidence, and produce a living threat actor profile that informs ongoing MDR detection and customer advisory work.

## Background

The Axios npm supply chain attack introduced `plain-crypto-js@4.2.1` as a malicious injected dependency, delivering a cross-platform RAT via `postinstall` lifecycle script. Known IOCs include C2 domain `sfrclak.com` (IP `142.11.206.73`), OS-specific file artifacts, and a Windows persistence key masquerading as `MicrosoftUpdate`.

The actor's tradecraft — targeting a massively popular developer library, delivering a cross-platform RAT, and focusing on CI/CD credential harvest — is consistent with several known APT clusters. This project establishes whether this is a known actor or a new one, and maps their broader campaign activity.

## Research Questions

1. Who published `plain-crypto-js@4.2.1`? What other packages has that account published?
2. What does infrastructure analysis of `sfrclak.com` / `142.11.206.73` reveal about actor identity and related campaigns?
3. Is the RAT codebase linked to a known malware family?
4. Which known APT groups match the observed TTPs, and at what confidence level?
5. What other npm (or cross-ecosystem) supply chain attacks are attributable or linkable to the same actor?

## Success Criteria

- Structured threat actor profile with confidence-graded attribution
- Campaign timeline linking the Axios attack to predecessor and successor campaigns
- Expanded IOC watch list ready for CTI Hunter ingestion
- MITRE ATT&CK technique mapping for the actor

## Assigned Agents

- Lead: Threat Actor Profiler
- Support: Campaign Correlator
- Review: Research Director
