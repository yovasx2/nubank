Dir["./lib/**/*.rb"].each {|file| require file }

class Authorizer

  attr_accessor :account

  def execute(input_hash)
    model = input_hash.keys.first
    processor = Object.const_get("#{model.capitalize}Processor")
    self.account = processor.process(self.account, input_hash[model])
    return AccountSerializer.serialize(self.account)
  end
end
