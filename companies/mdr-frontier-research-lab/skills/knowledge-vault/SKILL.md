# Skill: Knowledge Vault Integration

## Purpose

Read from and write to the personal knowledge vault at `/Users/hirok/personal-brain/My-Knowledge-Valut/`. All research, analysis, and investigation outputs produced by MDR agents must be persisted here. All agents must consult the vault before starting research to avoid duplicating existing knowledge.

## Vault Structure

```
/Users/hirok/personal-brain/My-Knowledge-Valut/
├── Raw/        ← 未処理のソース素材（記事・メモ・調査ノート）
├── Wiki/       ← 構造化ナレッジページ（1ページ1トピック）
│   ├── index.md  ← 全ページの目次（必ず更新）
│   └── log.md    ← 操作ログ（必ず記録）
└── Reports/    ← 調査・分析の出力ファイル
```

## Read Protocol — Research Start (Required)

Before starting any research task, run this sequence:

1. **Read `Wiki/index.md`** — identify pages relevant to the case/topic
2. **Read relevant Wiki pages** — follow `[[WikiLinks]]` to connected pages
3. **Check `Raw/`** — look for source documents related to the topic
4. **Note what is already known** — do not re-derive facts that are already in the Wiki

### Currently Known (as of 2026-05): Key Wiki Pages for MDR Research

| Topic | Wiki Page |
|-------|-----------|
| Axios supply chain attack | `Wiki/axios乗っ取り事件_2026.md` |
| Axios IOCs | `Wiki/IOC_axios乗っ取り事件_2026.md` |
| Threat actor (North Korea-nexus) | `Wiki/UNC1069.md` |
| RAT family | `Wiki/WAVESHAPER.md` |
| JS dropper | `Wiki/SILKBELL.md` |
| Related crypto campaign | `Wiki/UNC1069_暗号通貨キャンペーン_2026.md` |
| NK APT overview | `Wiki/北朝鮮APTグループ概観.md` |
| Supply chain attack patterns | `Wiki/サプライチェーン攻撃.md` |
| LiteLLM attack (related) | `Wiki/LiteLLM侵害事件_2026.md` |

## Write Protocol — Output Persistence (Required)

### Raw research notes and source materials → `Raw/`
Save when you:
- Collect a new source document or article
- Write raw investigation notes during a hunt run
- Dump IOC data before structuring it

Naming: `Raw/YYYY-MM-DD_topic-slug.md`

### Formal analysis outputs → `Reports/`
Save when you:
- Complete a hunt report
- Produce a threat actor attribution assessment
- Write a campaign correlation report
- Produce a customer advisory

Naming: `Reports/YYYY-MM-DD_report-title.md`

### Structured knowledge updates → `Wiki/`
Create or update a Wiki page when you:
- Discover a new threat actor, malware family, or campaign that doesn't have a page yet
- Find new IOCs that should be added to an existing IOC page
- Establish a new attribution link between campaigns
- Confirm or upgrade a confidence assessment

After any Wiki write:
- Update `Wiki/index.md` to include the new/updated page
- Append to `Wiki/log.md` with date and description of what changed

## File Format — Wiki Pages

```markdown
---
title: ページタイトル
tags:
  - tag1
  - tag2
source:
  - Raw/ソースファイル名.md
confidence: high | medium | low
last_verified: YYYY-MM-DD
---

# ページタイトル

本文。[[関連ページ]] へのリンクを積極的に使う。
```

## File Format — Reports

```markdown
---
title: レポートタイトル
date: YYYY-MM-DD
author: [agent name]
case: [case ID or name]
tags:
  - tag1
source_wiki:
  - Wiki/関連ページ.md
---

# レポートタイトル

本文。

## 参照

- [[Wiki/IOC_axios乗っ取り事件_2026]]
- [[Wiki/UNC1069]]
```

## Key Rules

- **Read before write.** Never produce a report without first checking the Wiki.
- **Update, don't duplicate.** If a Wiki page already exists for your topic, update it rather than creating a new one.
- **Link aggressively.** Use `[[PageName]]` to connect related Wiki pages.
- **Confidence grades.** Always set `confidence: high | medium | low` in frontmatter. Unverified claims must be `low`.
- **Source traceability.** Always list source files in the frontmatter `source` field.
- **Log every write.** Every Wiki create/update must be recorded in `Wiki/log.md`.
