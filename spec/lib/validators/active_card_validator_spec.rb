describe ActiveCardValidator do
  let(:account) { Account.new(100, active_card) }
  let(:transaction) { Transaction.new('burgers', 50, Time.now) }

  context 'when active_card is true' do
    let(:active_card) { true }

    it 'returns true' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(true)
    end

    it 'adds no violation' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.length).to eq(0)
    end
  end

  context 'when active_card is false' do
    let(:active_card) { false }

    it 'returns false' do
      result = described_class.is_valid?(account, transaction)
      expect(result).to eq(false)
    end

    it 'adds a violation to the account' do
      described_class.is_valid?(account, transaction)
      expect(account.violations.first).to eq('card-not-active')
    end
  end
end
