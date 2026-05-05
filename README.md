# pelica

家計簿と支出シミュレーションを統合した個人向けデスクトップアプリケーション。

> 本リポジトリは家計簿アプリのコードであり、個人の家計データは含まない。

## 特徴

- 取引データを連続したストリームとして保持し、フィルタの段階で月・年などの区切りが発生する設計
- 過去（実績）と未来（予定・予測）をシームレスに繋ぐ
- What-if スイッチで支払い・収入のシミュレーションが即座に可能
- イベントソーシング + CQRS で訂正・取消も履歴として記録

詳細な設計思想は [`CLAUDE.md`](./CLAUDE.md) を参照。

## 技術スタック

- **デスクトップ**: [Tauri](https://tauri.app/)
- **フロントエンド**: [Solid](https://www.solidjs.com/) + TypeScript
- **バックエンド**: Rust + SQLite（DB 配置: `~/.pelica/db`）
- **コード品質**: [Biome](https://biomejs.dev/)

## 開発環境セットアップ

### 前提

- Node.js / pnpm
- Rust toolchain（Tauri ビルドに必要）

### 初回セットアップ

```bash
pnpm install
```

### 開発起動

```bash
pnpm tauri dev
```

### コード整形・チェック

```bash
pnpm check    # format + lint + auto-fix
pnpm format   # format のみ
pnpm lint     # lint のみ
```

## ライセンス

MIT
