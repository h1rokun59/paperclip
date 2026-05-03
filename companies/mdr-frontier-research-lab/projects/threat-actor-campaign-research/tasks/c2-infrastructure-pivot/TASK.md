---
kind: task
slug: c2-infrastructure-pivot
name: C2 Infrastructure Pivot
assignee: campaign-correlator
project: threat-actor-campaign-research
---

# C2 Infrastructure Pivot

## Objective

Pivot from `sfrclak.com` and `142.11.206.73` to discover related infrastructure used by the same threat actor in this and other campaigns.

## Pivot Steps

### Domain Pivot: sfrclak.com
1. WHOIS history: registrant, registrar, creation date, registration email pattern
2. Passive DNS: all IPs this domain has resolved to; all domains that have resolved to the same IPs
3. Certificate transparency: TLS certs issued for `sfrclak.com` or co-hosted subdomains
4. Check VirusTotal, AlienVault OTX, Shodan for existing threat intel tagging

### IP Pivot: 142.11.206.73
1. ASN: who hosts this IP? Is the ASN associated with bulletproof hosting?
2. Shodan: what services are running on this IP? Other ports with similar service signatures?
3. Passive DNS: all domains that have resolved to this IP
4. Censys: certificate history for services on this IP
5. Subnet sweep: are adjacent IPs in the same /24 hosting other actor infrastructure?

### Related Infrastructure Hypothesis Testing
- Is `sfrclak.com` registered with a pattern (random 7-letter `.com`) used in other actor campaigns?
- Check if the same registrar/registrant pattern appears in Lazarus Group infrastructure reports
- Check if IP `142.11.206.73` or its /24 appears in any previous npm supply chain attack reporting

## Tools
- VirusTotal (domain/IP graph)
- Shodan: `net:142.11.206.73/24`
- Censys: `ip:142.11.206.73`
- crt.sh: `%.sfrclak.com`
- SecurityTrails or RiskIQ for passive DNS (if available via public API)
- AlienVault OTX for existing IOC tagging

## Output

- Infrastructure relationship map with confidence grades
- New related domains/IPs discovered
- Hosting provider assessment (actor-owned / bulletproof / compromised legitimate)
- Comparison with known Lazarus / APT41 / UNC4736 infrastructure patterns

## Assigned To

Campaign Correlator
