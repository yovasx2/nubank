class Account
  DEFAULT_VALIDATORS = ['ActiveCard', 'NonNegativeTransactionAmount', 'SufficientLimit', 'LowFrequencyInSmallInterval', 'SingleTransaction']

  attr_accessor :available_limit, :active_card, :violations
  attr_reader :validators, :transactions

  def initialize(available_limit, active_card, validators = nil)
    @available_limit = available_limit
    @active_card = active_card
    @violations = []
    @transactions = []
    @validators = validators || DEFAULT_VALIDATORS
  end

  def to_h
    {
      account: {
        activeCard: self.active_card,
        availableLimit: self.available_limit,
        violations: self.violations
      }
    }
  end

  def get_transactions(since)
    index = self.transactions.length - 1
    interval_transactions = []
    while index >= 0
      transaction = self.transactions[index]
      break if since > transaction.time
      interval_transactions.unshift(transaction)
      index -= 1
    end
    return interval_transactions
  end

  def perform(transaction)
    self.available_limit = self.available_limit - transaction.amount
    @transactions << transaction
  end
end
