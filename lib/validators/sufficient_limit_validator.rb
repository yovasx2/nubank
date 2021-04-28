class SufficientLimitValidator

  ERROR = 'insufficient-limit'

  def self.is_valid?(account, transaction)
    if account.available_limit < transaction.amount
      account.violations << ERROR unless account.violations.include?(ERROR)
      return false
    end
    return true
  end
end