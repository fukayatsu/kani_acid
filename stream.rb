require './kani'

Process.daemon if ARGV[0] == '-d'

@streaming = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
end

@kani = Kani.new

@streaming.user do |object|
  begin
    case object
    when Twitter::Tweet
      tweet = object
      unless tweet.user.attrs[:id_str] == ENV["TWITTER_ID"]
        @kani.lean_text(tweet.text)
      end
    when Twitter::Streaming::Event
      event = object
      unless event.source.attrs[:id_str] == ENV["TWITTER_ID"]
        @kani.on_event(event)
      end
    end
  rescue => e
    puts e.backtrace
  end
end

