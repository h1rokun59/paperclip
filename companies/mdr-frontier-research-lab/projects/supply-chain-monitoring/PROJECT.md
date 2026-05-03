# Project: Supply Chain Threat Monitoring Program

## Goal

Establish an ongoing, systematic monitoring program for npm and cross-ecosystem supply chain threats. Produce weekly hunt reports, maintain a living IOC watch list, and detect future campaigns before they become customer incidents.

## Scope

- npm registry (primary focus)
- PyPI (secondary)
- GitHub repository compromise indicators
- Public advisory feeds and vendor threat intel

## Deliverables

1. **IOC Watch List v1**: seeded from Axios case, maintained living document
2. **npm Sweep Methodology**: repeatable weekly sweep procedure
3. **Hunt Report Template**: standard format for weekly CTI Hunter output
4. **Routine Configuration**: CTI Hunter running every Monday 09:00

## Long-Term Operating Model

- CTI Hunter runs weekly routine, sweeps all watch list items and advisory feeds
- New findings go to Campaign Correlator (infrastructure/code pivots) or Threat Actor Profiler (attribution updates) as needed
- Monthly: Research Director reviews hunt report trend and updates virtual customer advisories
- Quarterly: full watch list review and pruning

## Assigned Agents

- Lead: CTI Hunter
- Support: Campaign Correlator, Threat Actor Profiler
- Review: Research Director
