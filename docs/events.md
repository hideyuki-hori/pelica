# Domain Events

pelica の全ドメインイベントのスキーマ定義。 イベントソーシングのイベントログに記録される単位。

## 共通フィールド

すべてのイベントが持つ共通フィールド：

| フィールド | 型 | 説明 |
|---|---|---|
| `event_id` | UUID | イベント一意識別子 |
| `event_type` | string | イベント種別（このドキュメントのセクション名） |
| `event_version` | integer | イベントスキーマのバージョン |
| `occurred_at` | datetime (ISO 8601) | ビジネス的に「いつ起きたか」（過去日付の記録も可） |
| `recorded_at` | datetime (ISO 8601) | 記録時刻（イベントログへの書き込み時刻） |

以下、各イベントの「ペイロード」（共通フィールド以外）を定義する。

## 取引系

### `IncomeRecorded`

収入があった。

| フィールド | 型 | 説明 |
|---|---|---|
| `transaction_id` | UUID | 取引一意識別子（訂正・取消で参照） |
| `account_id` | integer | 入金先口座 |
| `amount` | integer | 金額（通貨最小単位、JPY なら円） |
| `currency` | string | ISO 4217（例: `JPY`） |
| `category_id` | integer? | カテゴリ |
| `note` | string? | メモ |

### `ExpenseRecorded`

支出があった。

| フィールド | 型 | 説明 |
|---|---|---|
| `transaction_id` | UUID | 取引一意識別子 |
| `account_id` | integer | 出金元口座 |
| `amount` | integer | 金額（正の値で記録、内部で減算扱い） |
| `currency` | string | ISO 4217 |
| `category_id` | integer? | カテゴリ |
| `note` | string? | メモ |

### `TransferExecuted`

振替を実行した。

| フィールド | 型 | 説明 |
|---|---|---|
| `transaction_id` | UUID | 取引一意識別子 |
| `from_account_id` | integer | 出金元口座 |
| `to_account_id` | integer | 入金先口座 |
| `amount` | integer | 金額 |
| `currency` | string | ISO 4217 |
| `note` | string? | メモ |

## カード系

### `CardPurchased`

カードで購入した。

| フィールド | 型 | 説明 |
|---|---|---|
| `transaction_id` | UUID | 取引一意識別子 |
| `card_account_id` | integer | 使用したカード口座 |
| `amount` | integer | 利用金額 |
| `currency` | string | ISO 4217 |
| `category_id` | integer? | カテゴリ |
| `installment_count` | integer | 分割回数（1 なら一括、2 以上で分割払い、リボは別途） |
| `note` | string? | メモ |

### `CardPaymentScheduled`

締め日が来て支払予定が確定した。

| フィールド | 型 | 説明 |
|---|---|---|
| `card_account_id` | integer | 対象カード口座 |
| `closing_date` | date | 締め日 |
| `payment_due_date` | date | 支払予定日（営業日繰越後） |
| `amount` | integer | 支払予定額（締め日時点の利用合計） |
| `currency` | string | ISO 4217 |
| `payment_account_id` | integer | 引落口座 |

### `CardPaymentExecuted`

カード引き落としが実行された。

| フィールド | 型 | 説明 |
|---|---|---|
| `card_account_id` | integer | 対象カード口座 |
| `payment_account_id` | integer | 引落口座 |
| `amount` | integer | 引落額 |
| `currency` | string | ISO 4217 |
| `payment_date` | date | 実際の引落日 |

## ローン系

### `LoanContractStarted`

ローン契約を開始した。

| フィールド | 型 | 説明 |
|---|---|---|
| `loan_id` | UUID | ローン一意識別子 |
| `principal` | integer | 借入元金 |
| `currency` | string | ISO 4217 |
| `interest_rate` | decimal | 年利（例: `0.015` = 1.5%） |
| `term_months` | integer | 借入期間（月数） |
| `payment_method` | string | `equal_payment`（元利均等。MVP はこれのみ） |
| `started_at` | date | 契約開始日 |
| `monthly_payment_date` | integer | 毎月の引落日（1-31） |
| `debit_account_id` | integer | 引落口座 |
| `loan_type` | string | `housing` / `auto` / `education` / `consumer` |
| `note` | string? | メモ |

### `LoanRepaymentExecuted`

ローンの月次引落しが実行された。

| フィールド | 型 | 説明 |
|---|---|---|
| `loan_id` | UUID | ローン一意識別子 |
| `repayment_date` | date | 引落日 |
| `principal_portion` | integer | 元金充当額 |
| `interest_portion` | integer | 利息充当額 |
| `total_amount` | integer | 合計支払額（元金 + 利息） |
| `currency` | string | ISO 4217 |
| `debit_account_id` | integer | 引落口座 |

### `LoanPrepaid`

繰上返済を行った。

| フィールド | 型 | 説明 |
|---|---|---|
| `loan_id` | UUID | ローン一意識別子 |
| `prepayment_date` | date | 繰上返済日 |
| `amount` | integer | 繰上返済額（元金部分） |
| `currency` | string | ISO 4217 |
| `recalc_method` | string | `shorten_term`（期間短縮）/ `reduce_amount`（金額軽減） |
| `debit_account_id` | integer | 引落口座 |

### `LoanInterestRateChanged`

ローンの金利が変更された（変動金利向け、MVP では使わないが構造として定義）。

| フィールド | 型 | 説明 |
|---|---|---|
| `loan_id` | UUID | ローン一意識別子 |
| `effective_date` | date | 新金利の適用開始日 |
| `new_interest_rate` | decimal | 新金利（年利） |

## 訂正・取消系

### `TransactionCorrected`

過去の取引を訂正した。

| フィールド | 型 | 説明 |
|---|---|---|
| `original_transaction_id` | UUID | 訂正対象の取引 ID |
| `original_event_id` | UUID | 訂正対象のイベント ID |
| `corrected_payload` | object | 訂正後の値（元イベントと同じ構造） |
| `reason` | string? | 訂正理由 |

### `TransactionVoided`

取引を取り消した。

| フィールド | 型 | 説明 |
|---|---|---|
| `original_transaction_id` | UUID | 取消対象の取引 ID |
| `original_event_id` | UUID | 取消対象のイベント ID |
| `reason` | string? | 取消理由 |

## 表記規則

- `?` 付きフィールドは optional（nullable）
- 金額は通貨最小単位の整数で扱う（JPY なら円、浮動小数点は使わない）
- 日付は ISO 8601 (`YYYY-MM-DD`) 形式の date、日時は ISO 8601 datetime
- UUID は v4 を想定
- `decimal` の精度確保方法は実装段階で決定（SQLite なら REAL ではなく TEXT または整数の basis points 推奨）
