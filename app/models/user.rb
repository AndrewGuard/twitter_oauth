class User < ActiveRecord::Base
  has_many :tweets

  def tweets(options = {:count => 10})
    twitter_client.user_timeline(options)
  end

  private

  def twitter_client
    @twitter_client ||= Twitter::Client.new(
      :oauth_token => self.oauth_token,
      :oauth_token_secret => self.oauth_secret
    )
  end
end
