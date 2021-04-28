class SingleTransactionValidator

  MINUTES_AGO = 2 / 1440.0
  TRANSACTIONS_LIMIT = 1
  ERROR = 'doubled-transaction'.freeze

  def self.is_valid?(account, transaction)
    since = transaction.time - MINUTES_AGO
    interval_transactions = account.get_transactions(since)
    filtered_transactions = interval_transactions.select do |t|
      t.merchant == transaction.merchant && t.amount == transaction.amount
    end

    if filtered_transactions.count >= TRANSACTIONS_LIMIT
      account.violations << ERROR unless account.violations.include?(ERROR)
      return false
    end
    return true
  end
end