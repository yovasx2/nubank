class Transaction
  attr_accessor :merchant, :amount, :time

  def initialize(merchant, amount, time)
    @merchant = merchant
    @amount = amount
    @time = time
  end


  def self.instance(transaction_data)
    merchant = transaction_data['merchant']
    amount = transaction_data['amount']
    time = DateTime.parse(transaction_data['time'])
    return self.new(merchant, amount, time)
  end
end
