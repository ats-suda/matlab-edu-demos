# matlab-edu-demos

A growing collection of interactive MATLAB teaching demos — Live Scripts and GUI apps
for physics & engineering education. Learn by dragging sliders and watching plots
update in real time. Base MATLAB only, no extra toolboxes required.

インタラクティブなMATLAB教材集です。物理・工学教育向けに、Live Script と GUIアプリを
収録しています。スライダーを動かすとグラフがリアルタイムに更新されます。base MATLAB
のみで動作し、追加Toolboxは不要です。

---

## Demos / 収録デモ

| Demo / デモ | Topic / テーマ | Status / 状態 |
|---|---|---|
| [**spring-mass-damper/**](spring-mass-damper/) | Free vibration of a spring–mass–damper system / ばね-マス-ダンパ系の自由振動 | ✅ Available / 公開 |
| [**pid-control/**](pid-control/) | P / PI / PD / PID step-response comparison / P・PI・PD・PID のステップ応答比較 | ✅ Available / 公開 |
| `projectile-motion/` | Projectile motion (with/without air drag) / 放物線運動（空気抵抗あり/なし） | 🚧 In preparation / 準備中 |
| `fourier-series/` | Fourier-series approximation of a square wave / フーリエ級数による矩形波近似 | 🚧 In preparation / 準備中 |

Each demo lives in its own subfolder with a dedicated README. / 各デモはサブフォルダに
分かれ、専用のREADMEを備えています。

---

## Concept / コンセプト

**EN** — Each demo presents one topic in several styles so learners can pick what suits
them: a **static read-through**, an **interactive Live Script** with embedded sliders,
and a **standalone GUI app**. The emphasis is on *seeing* how a system responds when you
change its parameters, rather than reading equations alone.

**JA** — 各デモは1つのテーマを複数のスタイルで提供し、学習者が自分に合った形を選べます:
**通読向けの静的版**、スライダー埋め込みの**インタラクティブLive Script**、そして
**独立GUIアプリ**。数式を読むだけでなく、パラメータを変えたときに系がどう応答するかを
*見て*学べることを重視しています。

---

## Requirements / 動作環境

| | |
|---|---|
| MATLAB | **R2025a or later recommended** / **R2025a 以降推奨**（plain-text Live Script `.m` 対応）。`.mlx`・app は R2016b+ でも動作 |
| Toolboxes | **None / 不要**（base MATLAB のみ） |
| Tested on / 検証環境 | MATLAB R2026a (Windows 11) |

---

## How This Was Built / 開発の経緯

**EN** — This collection is developed through an agentic, AI-assisted workflow. Using
the **MATLAB Agentic Toolkit** and the **MATLAB MCP Server**, Claude (Anthropic's Claude
Code) drives a locally installed MATLAB in a conversational loop — authoring the code,
running the Code Analyzer, executing scripts, generating Live Scripts (`.mlx`) via the
Live Editor API, and verifying the on-screen rendering — while the human author guides
the design and reviews each iteration.

**JA** — 本コレクションは、エージェント型のAI支援ワークフローで開発しています。
**MATLAB Agentic Toolkit** と **MATLAB MCP Server** を用いて、Claude（AnthropicのClaude
Code）がローカルのMATLABを対話的に操作し、コード作成・コードアナライザー実行・
スクリプト実行・Live Editor API による `.mlx` 生成・表示確認までを担い、人間の著者が
設計方針を指示し各段階をレビューしています。

---

## License / ライセンス

BSD 3-Clause License. See [LICENSE.txt](LICENSE.txt). / BSD 3-Clause ライセンス。詳細は
[LICENSE.txt](LICENSE.txt) を参照してください。

---

## Author / 著者

- Author / 著者: **A. Suda**, National Institute of Technology (KOSEN), Nara College
