describe AccountSerializer do
  it 'serializes an account as json' do
    account = Account.new(100, true)
    serialized = AccountSerializer.serialize(account)
    expect(serialized).to eq('{"account":{"activeCard":true,"availableLimit":100,"violations":[]}}')
  end
end
