class TransactionProcessor
  def self.process(account, transaction_data)
    transaction = Transaction.instance(transaction_data)
    if self.is_valid?(account, transaction)
      account.perform(transaction)
    end
    account
  end

  def self.is_valid?(account, transaction)
    valid = true
    account.validators.each do |validator|
      validator = Object.const_get("#{validator}Validator")
      valid &&= validator.is_valid?(account, transaction)
    end
    return valid
  end
end
