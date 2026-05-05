CREATE TABLE loan_principals (
  loan_id TEXT PRIMARY KEY,
  principal_remaining INTEGER NOT NULL,
  interest_remaining INTEGER NOT NULL,
  repayments_remaining INTEGER NOT NULL,
  next_repayment_date TEXT,
  current_interest_rate TEXT NOT NULL,
  currency TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_loan_principals_next_date ON loan_principals(next_repayment_date);
