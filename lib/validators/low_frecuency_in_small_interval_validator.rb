require 'date'

class LowFrequencyInSmallIntervalValidator

  MINUTES_AGO = 2 / 1440.0
  TRANSACTIONS_LIMIT = 3
  ERROR = 'high-frequency-small-interval'.freeze

  def self.is_valid?(account, transaction)
    since = transaction.time - MINUTES_AGO
    interval_transactions = account.get_transactions(since)
    if interval_transactions.count >= TRANSACTIONS_LIMIT
      account.violations << ERROR unless account.violations.include?(ERROR)
      return false
    end
    return true
  end
end