CREATE TABLE card_payment_schedules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  card_account_id INTEGER NOT NULL,
  closing_date TEXT NOT NULL,
  payment_due_date TEXT NOT NULL,
  amount INTEGER NOT NULL,
  currency TEXT NOT NULL,
  payment_account_id INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (card_account_id, closing_date)
);

CREATE INDEX idx_cps_card ON card_payment_schedules(card_account_id);
CREATE INDEX idx_cps_payment_due_date ON card_payment_schedules(payment_due_date);
