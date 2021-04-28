require 'json'
require './lib/authorizer'

results = []
authorizer = Authorizer.new
while ARGF.gets
  results << authorizer.execute(JSON.parse($_))
end
puts results
