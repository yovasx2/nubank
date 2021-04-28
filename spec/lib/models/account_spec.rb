describe Account do
  let(:account) { Account.new(100, true) }
  let(:transactions) { [ transaction1, transaction2 ] }
  let(:transaction1) { Transaction.new('burguers', 20, DateTime.parse('2021-04-28 02:40:23 +0000')) }
  let(:transaction2) { Transaction.new('burguers', 20, DateTime.parse('2021-04-28 02:50:23 +0000')) }

  context '#to_h' do
    it 'creates a hash with the correct values' do
      expected_hash = {
        account: {
          activeCard: true,
          availableLimit: 100,
          violations: []
        }
      }
      expect(account.to_h).to eq(expected_hash)
    end
  end

  context '#get_transactions' do
    it 'returns the transactions since 5 minutes ago of the last' do
      allow(account).to receive(:transactions).and_return(transactions)
      interval_transactions = account.get_transactions(transaction2.time - (5/1440.0))
      expect(interval_transactions.length).to eq(1)
      expect(interval_transactions.first).to eq(transaction2)
    end

    it "doesn't return the transactions outside the interval" do
      allow(account).to receive(:transactions).and_return(transactions)
      interval_transactions = account.get_transactions(transaction2.time - (5/1440.0))
      expect(interval_transactions).not_to include(transaction1)
    end
  end

  context '#perform' do
    it 'substract the amount of the transaction from the account available_limit' do
      account.perform(transaction1)
      expect(account.available_limit).to eq(80)
    end
  end
end
