# Skill: Supply Chain OSINT

## Purpose

Open-source intelligence collection techniques specific to software supply chain threat research. Covers package registries, publisher accounts, dependency graphs, and build pipeline exposure.

## Package Registry Research

### npm
- Registry API: `https://registry.npmjs.org/<package>` — full package metadata, version history, dist-tags
- Publisher lookup: `https://www.npmjs.com/~<username>` — all packages by a publisher
- Download stats: `https://api.npmjs.org/downloads/point/last-week/<package>`
- Dependency tree: use `npm ls` or `https://npmgraph.js.org`
- Audit: `npm audit --json` against a package.json
- Socket analysis: `https://socket.dev/npm/package/<package>`
- Phylum analysis: `https://app.phylum.io/projects/`

### PyPI
- Package metadata: `https://pypi.org/pypi/<package>/json`
- Publisher history: `https://pypi.org/user/<username>/`
- PyPI malware reports: `https://github.com/pypa/advisory-database`

### Other Registries
- RubyGems: `https://rubygems.org/gems/<gem>`
- Crates.io: `https://crates.io/crates/<crate>`
- Maven Central: `https://search.maven.org/`
- GitHub Packages: searchable via `https://github.com/search?type=code`

## Publisher Account Analysis

When investigating a suspicious publisher:
1. Check account creation date (very new account publishing high-value typosquat = red flag)
2. Enumerate all packages by the account — look for patterns (same-day bulk publish, spoofed names)
3. Check if the account has contributed to legitimate repos (social proof or hijacked account?)
4. Look for the email domain if exposed in npm metadata
5. Search GitHub for the username — linked repos, commit history, email in commits
6. Check for the same username on PyPI, GitHub, Bitbucket, npm — actor may reuse identities

## Dependency Confusion and Typosquat Patterns

Red flags for malicious packages:
- Package name is a close misspelling of a popular package
- Package name matches an internal namespace convention (dependency confusion)
- `postinstall`, `preinstall`, or `install` script that fetches a remote resource
- `scripts.install` pointing to an obfuscated or encoded command
- Empty or minimal README with no legitimate use case
- Version number out of step with the spoofed package
- Published hours/days before a major upstream release or security event

## CI/CD Exposure Analysis

When assessing a customer's supply chain exposure:
1. Identify which CI workflows run `npm install` without `--ignore-scripts`
2. Identify which workflows use semver ranges vs pinned versions vs lockfiles
3. Map which workflows have access to deployment secrets, cloud credentials, or signing keys
4. Identify Dependabot/Renovate configurations that might auto-merge dependency PRs
5. Check if container base images include package manager caches with potentially stale lockfiles

## OSINT Source List (Supply Chain Focus)

| Source | What it gives you |
|--------|------------------|
| Socket.dev | Real-time npm/PyPI malware analysis, postinstall detection |
| Phylum | Package risk scoring, malware campaign tracking |
| Checkmarx SCS | Supply chain security research, IOC reports |
| Snyk Advisor | Package health, vulnerability history |
| OSV.dev | Cross-ecosystem vulnerability database |
| npm audit DB | Official npm advisory feed |
| deps.dev | Dependency graph and vulnerability mapping |
| GitHub Advisory DB | GHSA advisories with version ranges |
