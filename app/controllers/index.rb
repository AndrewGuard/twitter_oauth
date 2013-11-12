# ======= GET ===========================================

get '/' do
  erb :index
end

get '/sign_in' do
  redirect request_token.authorize_url
end

get '/sign_out' do
  logout
  redirect '/'
end

get '/auth' do
  access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  session.delete(:request_token)

  user = User.find_or_initialize_by_username(access_token.params[:screen_name])
  user.update_attributes(oauth_token: access_token.token, oauth_secret: access_token.secret)
  login(user)

  redirect to '/tweets'
end

get '/tweets' do
  erb :view_tweets
end

# ========= POST ===========================================

post '/create_tweet' do 

  tweeter = Twitter.configure do |config|
    config.oauth_token = current_user.oauth_token
    config.oauth_token_secret = current_user.oauth_secret
  end

  tweeter.update(params[:tweet])

  redirect to '/tweets'
end
