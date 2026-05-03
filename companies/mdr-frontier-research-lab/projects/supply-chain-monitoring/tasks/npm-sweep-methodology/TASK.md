# Task: Document npm Sweep Methodology

## Objective

Write a repeatable, step-by-step methodology for the weekly npm registry sweep. This becomes the standard operating procedure for CTI Hunter's routine runs.

## Methodology to Document

### Step 1: Advisory Feed Check (15 min)
- GitHub Advisory Database: filter by `npm` ecosystem, last 7 days
- npm security advisories RSS or API
- OSV.dev: `https://osv.dev/list?ecosystem=npm`, last 7 days
- Socket Research blog: new posts in last 7 days
- Phylum blog: new posts in last 7 days
- Snyk blog: supply chain tag

### Step 2: Watch List Infrastructure Check (15 min)
For each tracked domain and IP:
- VirusTotal: any new detections or file associations?
- Passive DNS: any new domain-IP associations?
- Shodan: any service changes on tracked IPs?

### Step 3: npm Publisher Account Sweep (20 min)
For each tracked publisher account:
- Check for new packages published since last run
- For any new package: check `postinstall` script, README, download count, age

### Step 4: Pattern-Based Registry Sweep (20 min)
Search npm for new packages matching risk patterns:
- Recently published packages with `postinstall` that contains `curl`, `wget`, `fetch`, `http`, `download`
- Package names that are close variants of `axios`, `lodash`, `express`, `react`, `webpack`, `typescript`
- Packages with 0 downloads, no README, created in last 7 days, with a `postinstall` script
- Use Socket.dev bulk analysis or Phylum feeds if API access is available

### Step 5: Vendor Intel Sweep (10 min)
- Microsoft MSTIC blog: new posts mentioning npm, supply chain, developer targeting
- Mandiant/Google TAG: new reports on developer-targeting campaigns
- CISA alerts: new advisories mentioning supply chain or npm
- CrowdStrike blog: new threat actor activity

### Step 6: Findings Triage and Report (20 min)
- Grade each finding
- Determine: add to watch list / escalate immediately / include in weekly report / discard
- Write weekly hunt report using CTI Hunt Reporting skill template

## Total Estimated Time Per Run
~90 minutes per weekly sweep

## Assigned To

CTI Hunter (document to be saved as issue document `npm-sweep-sop`)
