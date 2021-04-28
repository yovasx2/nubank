describe LowFrequencyInSmallIntervalValidator do
  let(:account) { Account.new(100, true) }
  let(:transaction) { Transaction.new('burgers', 50, Time.now) }

  context 'when there are less than 3 transactions in a 2 minutes interval' do
    before do
      allow(account).to receive(:get_transactions).and_return([transaction, transaction])
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

  context 'when there are 3 or more transactions in a 2 minutes interval' do
    before do
      allow(account).to receive(:get_transactions).and_return([transaction, transaction, transaction])
    end

    it 'returns false' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(false)
    end

    it 'adds a violation to the account' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.first).to eq('high-frequency-small-interval')
    end
  end
end
