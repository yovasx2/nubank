describe TransactionProcessor do
  before do
    allow(Account).to receive(:new).and_return(account)
  end

  let(:transaction_data) do { 'merchant' => true, 'amount' => 50, 'time' => DateTime.now.iso8601 } end
  let(:account) { Account.new(100, active_card) }

  context 'when a validator returns false' do
    let(:active_card) { false }

    it 'adds a violation to the account' do
      created_account = described_class.process(account, transaction_data)
      expect(created_account.violations.first).to eq('card-not-active')
    end

    it "doesn't process the transaction" do
      created_account = described_class.process(account, transaction_data)
      expect(created_account.available_limit).to eq(100)
    end
  end

  context 'when all validators return true' do
    let(:active_card) { true }

    it 'process the transaction' do
      created_account = described_class.process(account, transaction_data)
      expect(created_account.available_limit).to eq(50)
    end

    it "doesn't add a violation" do
      created_account = described_class.process(account, transaction_data)
      expect(created_account.violations.length).to eq(0)
    end
  end
end
