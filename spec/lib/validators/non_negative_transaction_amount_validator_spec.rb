describe NonNegativeTransactionAmountValidator do
  let(:account) { Account.new(100, true) }

  context 'when the transaction.amount is smaller or equal to zero' do
    let(:transaction) { Transaction.new('burgers', -50, Time.now) }

    it 'returns false' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(false)
    end

    it 'adds a violation to the account' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.first).to eq(NonNegativeTransactionAmountValidator::ERROR)
    end
  end

  context 'when the transaction.amount is greater than zero' do
    let(:transaction) { Transaction.new('burgers', 10, Time.now) }

    it 'returns false' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(true)
    end

    it 'adds no violation' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.length).to eq(0)
    end
  end
end
