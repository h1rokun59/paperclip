# Task: RAT Codebase Fingerprinting

## Objective

Identify whether the cross-platform RAT delivered in the Axios supply chain attack is a known malware family, a derivative, or a novel tool. Establish code-level fingerprints for future campaign matching.

## Known Artifacts to Use as Seeds

- macOS: `/Library/Caches/com.apple.act.mond` (persistence artifact)
- Linux: `/tmp/ld.py` (Python dropper)
- Windows: `%TEMP%\6202033.vbs`, `%TEMP%\6202033.ps1`, `%PROGRAMDATA%\wt.exe`
- Windows persistence: `HKCU\Software\Microsoft\Windows\CurrentVersion\Run\MicrosoftUpdate`
- C2: `http://sfrclak.com:8000/6202033`
- Postinstall entry point: `node setup.js` within `plain-crypto-js`

## Research Steps

1. **Search Malware Bazaar / Any.run / Hybrid Analysis**
   - Search for samples with filename `ld.py`, `6202033.vbs`, `6202033.ps1`, `wt.exe`
   - Search for C2 pattern `sfrclak.com` or `142.11.206.73`
   - Search for samples tagged with `postinstall` or `npm` delivery

2. **Search VirusTotal**
   - Search for files with name `ld.py` from npm-related submissions
   - Use VT Intelligence (if available) for YARA-style search on known strings

3. **GitHub code search**
   - Search for `sfrclak` to find any public disclosure or sandbox reports
   - Search for `com.apple.act.mond` to find researcher reports
   - Search for `6202033` combined with npm or RAT terms

4. **Known RAT Family Comparison**
   Compare observed TTPs against:
   - **AsyncRAT**: .NET-based, cross-platform C2, often used in npm campaigns
   - **QuasarRAT**: open source .NET, similar persistence patterns
   - **Dacls / POOLRAT**: Lazarus Group macOS RATs, similar persistence in `/Library/Caches/`
   - **NimRAT / NimPlant**: Nim-based cross-platform, newer Lazarus tooling
   - **MeshAgent**: legitimate RMM tool sometimes abused

5. **Assess macOS Persistence Pattern**
   - `com.apple.act.mond` mimics Apple system process naming
   - This specific pattern (Apple-spoofing in `/Library/Caches/`) has been seen in Lazarus macOS campaigns
   - Check Objective-See (Patrick Wardle) blog for matching macOS malware analysis

## Output

- RAT family classification: Known family / Derivative / Novel
- Confidence grade for classification
- Code fingerprints: strings, paths, patterns usable in YARA/detection rules
- Actor linkage assessment based on tooling overlap
- List of similar samples if found

## Assigned To

Threat Actor Profiler (with support from Detection Engineering Lead for YARA rule drafting)
