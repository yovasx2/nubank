describe AccountProcessor do
  before do
    allow(Account).to receive(:new).and_return(account)
  end

  let(:account_data) do { 'activeCard' => true, 'availableLimit' => 100 } end
  let(:account) { Account.new(100, true) }

  context "when no account is passed" do
    it 'process the account' do
      created_account = described_class.process(nil, account_data)
      expect(created_account).to eq(account)
    end
  end

  context 'when an account is passed' do
    it 'adds a violation to the account' do
      created_account = described_class.process(account, account_data)
      expect(created_account.violations.first).to eq('account-already-initialized')
    end
  end
end
