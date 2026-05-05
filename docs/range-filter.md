# Range Filter

pelica の取引・予測表示で使う「期間指定フィルタ」の構文定義。

## 構文

```
range <clause>

clause:
  since:<date> [until:<date>]      期間指定（until 省略時は今日まで）
  last:<duration>                  直近指定
  month:<YYYY-MM>                  月単位（その月の 1 日〜末日）
  year:<YYYY>                      年単位（その年の 1/1〜12/31）
  week:<YYYY-Www>                  週単位（ISO 8601 の週、 月曜始まり）

date:     YYYY-MM-DD（ISO 8601 の date）
duration: <integer><unit>
unit:     d (日) / w (週) / m (月) / y (年)
```

## 例

- `range since:2026-01-01 until:2026-01-31` 1月1日〜31日
- `range since:2026-01-01` 1月1日〜今日
- `range last:30d` 今日から過去 30 日
- `range last:6m` 今日から過去 6 ヶ月
- `range month:2026-01` 2026 年 1 月
- `range year:2026` 2026 年
- `range week:2026-W05` 2026 年第 5 週

## 仕様

### since の until 省略時
`until` が省略された場合は「今日」を末尾とする。

### last の起点
`last:N<unit>` は「今日を含む過去 N の単位ぶん」を意味する。 例: `last:30d` は今日を含む過去 30 日間。

### 週指定
`week:<YYYY-Www>` は ISO 8601 の週番号（月曜始まり）。 第 1 週はその年で初めて木曜日を含む週。

### 未来の range
`until` が未来日の場合、 期間内に予測区間を含む。 予測支出は過去平均ベースで自動投影される（CLAUDE.md「range フィルタの動作」を参照）。

### 逆順 / 不正な値
- `since > until` は invalid（エラー）
- 不正な日付（例: `2026-02-30`）は invalid
- 不正な単位（例: `last:5x`）は invalid

### 大文字小文字
clause name と unit はすべて lowercase 扱い。 `SINCE:`, `M`, `Y` などは認めない。
