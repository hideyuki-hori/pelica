CREATE TABLE installments (
  transaction_id TEXT PRIMARY KEY,
  card_account_id INTEGER NOT NULL,
  total_count INTEGER NOT NULL,
  remaining_count INTEGER NOT NULL,
  monthly_amount INTEGER NOT NULL,
  currency TEXT NOT NULL,
  next_payment_date TEXT,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_inst_card ON installments(card_account_id);
CREATE INDEX idx_inst_next_payment_date ON installments(next_payment_date);
