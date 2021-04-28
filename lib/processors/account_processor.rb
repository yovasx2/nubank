class AccountProcessor
  def self.process(account, account_data)
    if account
      account.violations << 'account-already-initialized'
    else
      account = Account.new(account_data['availableLimit'], account_data['activeCard'])
    end
    account
  end
end

