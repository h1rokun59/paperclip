# Task: npm Publisher Account Pivot

## Objective

Enumerate and analyze the npm publisher account that published `plain-crypto-js@4.2.1`. Determine if the same account has published other packages, and assess whether those packages are malicious or suspicious.

## Steps

1. Use npm registry API to fetch `plain-crypto-js` metadata and identify the publisher account
   - `https://registry.npmjs.org/plain-crypto-js`
2. Enumerate all packages published by that account
   - `https://www.npmjs.com/~<username>`
3. For each package: check download counts, creation date, README quality, `scripts.postinstall` presence
4. Cross-reference publisher username with GitHub, PyPI, Bitbucket
5. Check Socket.dev and Phylum for any existing analysis of this publisher or their packages
6. Look for email patterns in package metadata (some npm packages expose publisher email in dist metadata)
7. Check if the account shows signs of being a legitimate account that was hijacked vs. a purpose-built malicious account

## Output

- Publisher account profile: username, account age, all known packages
- Risk assessment for each discovered package
- Confidence grade for whether this is an actor-controlled account vs. hijacked legitimate account
- New IOCs (additional malicious packages) ready for watch list ingestion

## Assigned To

Threat Actor Profiler
