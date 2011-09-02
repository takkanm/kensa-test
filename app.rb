require 'sinatra'
require 'json'

use Rack::Auth::Basic do |name, pass|
  name == 'myaddon' && pass == 'HAyCiYuDIX5NWXPv'
end

post '/heroku/resources' do
  {id: 1, config: {MYADDON_HELLO: 'hello'}}.to_json
end
