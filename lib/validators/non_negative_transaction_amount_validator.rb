class NonNegativeTransactionAmountValidator

  ERROR = 'transaction-amount-must-be-greater-than-zero'

  def self.is_valid?(account, transaction)
    if transaction.amount <= 0
      account.violations << ERROR unless account.violations.include?(ERROR)
      return false
    end
    return true
  end
end