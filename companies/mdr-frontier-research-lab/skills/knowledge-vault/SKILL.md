# Skill: Knowledge Vault Integration

## Purpose

Read from and write to the personal knowledge vault at `/Users/hirok/personal-brain/My-Knowledge-Valut/`. All agents must consult the vault before starting research. Write access to `Raw/` and `Wiki/` is restricted to Research Director only. Other agents write drafts to `Reports/` and request Research Director review.

## Vault Structure

```
/Users/hirok/personal-brain/My-Knowledge-Valut/
├── Raw/        ← 承認済みソース素材（Research Director のみ書き込み可）
├── Wiki/       ← 構造化ナレッジページ（Research Director のみ書き込み可）
│   ├── index.md  ← 全ページの目次
│   └── log.md    ← 操作ログ
└── Reports/    ← 全エージェントが下書きを置く場所。RD がここから Raw/Wiki/ に昇格させる
```

## Write Permissions by Role

| 場所 | Research Director | その他のエージェント |
|------|:-----------------:|:--------------------:|
| `Raw/` | ✅ 書き込み可 | ❌ 読み取りのみ |
| `Wiki/` | ✅ 書き込み可 | ❌ 読み取りのみ |
| `Reports/` | ✅ | ✅ |

**Research Director 以外のエージェントは `Raw/` と `Wiki/` に直接書いてはいけない。** 成果物は必ず `Reports/` に置き、Research Director のレビューを待つ。

## Read Protocol — Research Start (全エージェント必須)

研究タスクを始める前に必ずこの順で読む：

1. **`Wiki/index.md` を読む** — 関連ページを特定する
2. **関連 Wiki ページを読む** — `[[WikiLinks]]` を辿って芋づる式に収集する
3. **`Raw/` を確認する** — 関連するソース素材があれば読む
4. **既知の情報を把握してから着手する** — Wiki にある事実を再導出しない

### 現時点（2026-05）の主要参照ページ

| トピック | Wiki ページ |
|---------|------------|
| Axios サプライチェーン攻撃 | `Wiki/axios乗っ取り事件_2026.md` |
| Axios IOC 一覧 | `Wiki/IOC_axios乗っ取り事件_2026.md` |
| 脅威アクター（北朝鮮系） | `Wiki/UNC1069.md` |
| RAT ファミリー | `Wiki/WAVESHAPER.md` |
| JS ドロッパー | `Wiki/SILKBELL.md` |
| 関連暗号通貨キャンペーン | `Wiki/UNC1069_暗号通貨キャンペーン_2026.md` |
| 北朝鮮 APT 概観 | `Wiki/北朝鮮APTグループ概観.md` |
| サプライチェーン攻撃パターン | `Wiki/サプライチェーン攻撃.md` |
| LiteLLM 侵害（関連） | `Wiki/LiteLLM侵害事件_2026.md` |

## Write Protocol — Research Agents (Research Director 以外)

成果物は `Reports/` に保存し、Paperclip の Issueコメントで Research Director にレビューを依頼する。

```
Reports/YYYY-MM-DD_[case-id]_[report-type].md
例: Reports/2026-05-04_MDR-AXIOS-001_cti-hunt-report.md
```

Reports ファイルの先頭には以下を含める：
- 参照した Wiki ページのリスト
- 新たに判明した事実（Raw/Wiki に昇格させる候補）
- Research Director への確認事項

## Write Protocol — Research Director のみ

### Raw/ への保存

Research Director が内容を確認し、永続化する価値があると判断した場合のみ `Raw/` に移動または新規作成する。

```
Raw/YYYY-MM-DD_topic-slug.md
```

### Wiki/ の更新（インジェスト手順）

`Raw/` に新しいファイルが追加されたら、以下の手順で `Wiki/` に反映する：

1. ソースを注意深く読み、重要な概念・人物・組織・技術・イベントを抽出する
2. 既存の `Wiki/` を確認し、既存ページに統合すべきか新規ページに分けるべきか判断する
3. 必要なページを `Wiki/` に作成または更新する
4. 各ページに YAML フロントマターを付ける（下記フォーマット参照）
5. ページ間を `[[ページ名]]` で接続する
6. `Wiki/index.md` を更新する
7. `Wiki/log.md` に作業内容を記録する

### Wiki ページのフォーマット

```markdown
---
title: ページタイトル
tags:
  - tag1
  - tag2
  - tag3
source:
  - Raw/ソースファイル名.md
confidence: high | medium | low
last_verified: YYYY-MM-DD
---

# ページタイトル

本文。[[関連ページ]] へのリンクを積極的に使う。
```

## Key Rules

- **Read before write.** Wiki を確認してから着手する。
- **Update, don't duplicate.** 既存ページがあれば新規作成より更新を優先する。
- **Reports は下書き。** Raw/Wiki への昇格は Research Director の判断で行う。
- **Confidence grades.** `confidence: high | medium | low` を必ず設定する。未検証は `low`。
- **Log every write.** Research Director が Wiki を更新するたびに `Wiki/log.md` に記録する。
