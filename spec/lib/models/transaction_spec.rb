describe Transaction do
  let(:transaction_data) do
    {
      'merchant' => 'burguers',
      'amount' => 50,
      'time' => '2021-04-28 02:57:23 +0000'
    }
  end

  context '.instance' do
    it 'creates an instance of transaction' do
      transaction = described_class.instance(transaction_data)
      expect(transaction).to be_a(described_class)
    end

    it 'assigns the correct values' do
      transaction = described_class.instance(transaction_data)
      expect(transaction.merchant).to eq(transaction_data['merchant'])
      expect(transaction.amount).to eq(transaction_data['amount'])
      expect(transaction.time).to eq(DateTime.parse(transaction_data['time']))
    end
  end
end
