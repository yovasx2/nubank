class ActiveCardValidator

  ERROR = 'card-not-active'.freeze

  def self.is_valid?(account, transaction)
    unless account.active_card
      account.violations << ERROR unless account.violations.include?(ERROR)
      return false
    end
    return true
  end
end