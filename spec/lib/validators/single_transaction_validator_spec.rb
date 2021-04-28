describe SingleTransactionValidator do
  let(:account) { Account.new(100, true) }
  let(:transaction) { Transaction.new('burgers', 50, Time.now) }

  context 'when there is no transaction with the same merchant and the same amount' do
    before do
      allow(account).to receive(:get_transactions).and_return([])
    end

    it 'returns true' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(true)
    end

    it 'adds no violation' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.length).to eq(0)
    end
  end

  context 'when there is 1 transaction with the same merchant and the same amount' do
    before do
      allow(account).to receive(:get_transactions).and_return([transaction])
    end

    it 'returns false' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(false)
    end

    it 'adds a violation to the account' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.first).to eq('doubled-transaction')
    end
  end
end
