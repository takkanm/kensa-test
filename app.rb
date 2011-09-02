require 'sinatra'
require 'json'
require 'digest'
require 'open-uri'

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['myaddon', 'HAyCiYuDIX5NWXPv']
  end
end

post '/heroku/resources' do
  protected!
  {id: 1, config: {MYADDON_HELLO: 'hello'}}.to_json
end

HEROKU_SSO_SALT = "8TSXRg970l4a50oD"

get "/heroku/resources/:id" do
  pre_token = params[:id] + ':' + HEROKU_SSO_SALT + ':' + params[:timestamp]
  token = Digest::SHA1.hexdigest(pre_token).to_s

  halt 403 if token != params[:token]
  halt 403 if params[:timestamp].to_i < (Time.now - 2*60).to_i

  halt 404 unless params[:id] == '111'

  session[:user] = '111'
  session[:heroku_sso] = true
  response.set_cookie('heroku-nav-data', :value => params['nav-data'], :path => '/')
  redirect "/dashboard"
end

get '/dashboard' do
  erb :dashboard
end

def nav_header
  open('http://nav.heroku.com/v1/providers/header').read
end

__END__
@@ dashboard
<%= nav_header %>
<p>hello!!</p>
