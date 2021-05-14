describe Authorizer do
  subject { described_class.new }

  context '#execute' do
    context 'one account with valid transactions' do
      it 'applies all the transactions to the account' do
        input = [
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } },
          { 'transaction' => { 'merchant' => 'Burger King1', 'amount' => 2, 'time' => '2019-02-13T10:05:01.000Z' } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":true,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":8,"violations":[]}}'
        ])
      end
    end

    context 'double attempt of account creation' do
      it 'adds a violation to the account' do
        input = [
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } },
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":true,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":10,"violations":["account-already-initialized"]}}'
        ])
      end
    end

    context 'active_card validator returns false' do
      it 'adds a violation to the account' do
        input = [
          { 'account' => { 'activeCard' => false, 'availableLimit' => 10 } },
          { 'transaction' => { 'merchant' => 'Burger King', 'amount' => 2, 'time' => '2019-02-13T10:05:01.000Z' } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":false,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":false,"availableLimit":10,"violations":["card-not-active"]}}'
        ])
      end
    end

    context 'sufficient_limit validator returns false' do
      it 'adds a violation to the account' do
        input = [
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } },
          { 'transaction' => { 'merchant' => 'Burger King', 'amount' => 12, 'time' => '2019-02-13T10:05:01.000Z' } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":true,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":10,"violations":["insufficient-limit"]}}'
        ])
      end
    end

    context 'single_transaction validator returns false' do
      it 'adds a violation to the account' do
        input = [
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } },
          { 'transaction' => { 'merchant' => 'Burger King', 'amount' => 2, 'time' => '2019-02-13T10:05:01.000Z' } },
          { 'transaction' => { 'merchant' => 'Burger King', 'amount' => 2, 'time' => '2019-02-13T10:05:02.000Z' } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":true,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":8,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":8,"violations":["doubled-transaction"]}}'
        ])
      end
    end

    context 'low_frequency_in_small_interval validator return false' do
      it 'adds a violation to the account' do
        input = [
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } },
          { 'transaction' => { 'merchant' => 'Burger King', 'amount' => 2, 'time' => '2019-02-13T10:05:01.000Z' } },
          { 'transaction' => { 'merchant' => 'Mac Donalds', 'amount' => 2, 'time' => '2019-02-13T10:05:02.000Z' } },
          { 'transaction' => { 'merchant' => 'Sixties', 'amount' => 2, 'time' => '2019-02-13T10:05:03.000Z' } },
          { 'transaction' => { 'merchant' => "Carl's Junior", 'amount' => 2, 'time' => '2019-02-13T10:05:04.000Z' } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":true,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":8,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":6,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":4,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":4,"violations":["high-frequency-small-interval"]}}'
        ])
      end
    end

    context 'non_negative_transaction_amount validator return false' do
      it 'adds a violation to the account' do
        input = [
          { 'account' => { 'activeCard' => true, 'availableLimit' => 10 } },
          { 'transaction' => { 'merchant' => 'Burger King', 'amount' => -2, 'time' => '2019-02-13T10:05:01.000Z' } }
        ]
        results = input.map { |input_hash| subject.execute(input_hash) }
        expect(results).to eq([
          '{"account":{"activeCard":true,"availableLimit":10,"violations":[]}}',
          '{"account":{"activeCard":true,"availableLimit":10,"violations":["transaction-amount-must-be-greater-than-zero"]}}'
        ])
      end
    end
  end
end
