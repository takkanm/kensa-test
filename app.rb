require 'sinatra'
require 'json'

use Rack::Auth::Basic do |name, pass|
  name == 'myaddon' && pass == 'HAyCiYuDIX5NWXPv'
end

post '/heroku/resources' do
  {id: 1}.to_json
end
