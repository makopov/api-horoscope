require 'dotenv'
Dotenv.load
require 'httparty'
require 'oauth'
require 'sinatra'

def authenticateTwitter()
  consumer = OAuth::Consumer.new(
    ENV['API_KEY'], ENV['API_SECRET'],
    { site: 'https://api.twitter.com', scheme: 'header' }
  )
  token_hash = { oauth_token: ENV['ACCESS_TOKEN'], oauth_token_secret: ENV['ACCESS_TOKEN_SECRET'] }
  return access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
end

def postToTwitter(message)
  access_token = authenticateTwitter()
  
  update_url = 'https://api.twitter.com/1.1/statuses/update.json'
  access_token.request(:post, update_url, status: message)
end

post '/prediction' do
  postToTwitter(params[:postToTwitter])
end

get '/' do
  wiki_url = 'https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=1&format=json'
  wiki_results = HTTParty.get(wiki_url)

  @prediction = wiki_results["query"]["random"][0]["title"]
  erb :index
end
