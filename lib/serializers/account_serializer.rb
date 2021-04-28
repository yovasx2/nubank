class AccountSerializer
  def self.serialize(data)
    data.to_h.to_json
  end
end
