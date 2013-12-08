require 'dotenv'
Dotenv.load

KANI_ENV = ENV['KANI_ENV'] || 'development'

require 'bundler'
Bundler.require(:default, KANI_ENV)

require 'okura/serializer'
dict_dir = 'lib/okura-dic'
TAGGER   = Okura::Serializer::FormatInfo.create_tagger dict_dir

ActiveRecord::Base.establish_connection(YAML.load_file('db/config.yml')[KANI_ENV])
require_relative 'models/chain'
require_relative 'models/sentence'
require_relative 'models/configs'

class Kani
  def initialize
    @twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
  end

  def lean_words
    search_result = @twitter.search('ほっこり', result_type: "recent", count: 100, since_id: Configs.search_since_id)
    Configs.search_since_id = search_result.first.attrs[:id_str]
    search_result.each do |tweet|
      text = tweet.text
        .gsub(/@[a-zA-Z0-9_]+/, '')
        .gsub(/[a-zA-Z0-9_]+:/, '')
        .gsub(%r!https?://\S*!, '')
        .gsub('RT', '')
        .gsub('QT', '')
        .strip

      words = TAGGER.wakati(text)
      words.map! { |word| word == "BOS/EOS" ? nil : word }

      words.each_cons(3) do |head, neck, word|
        Chain.where(head: head, neck: neck, word: word).first_or_create
      end
    end
  end

  def tweet_something
    while !(sentence = generate_sentence) do; end

    sentence.tweeted_at = Time.now
    sentence.save!
    status = @twitter.update(sentence.body)
    sentence.status_id = status.attrs[:id_str]
    sentence.save!
  end

  def on_event(event)
    case event.name
    when :favorite
      status_id = event.target_object.attrs[:id_str]
      sentence = Sentence.where(status_id: status_id).first
      return if sentence.blank?
      sentence.fav_count += 1
      sentence.save
      sentence.chains.each do |chain|
        chain.weight += 20
        chain.save
      end
    when :unfavorite
      status_id = event.target_object.attrs[:id_str]
      sentence = Sentence.where(status_id: status_id).first
      return if sentence.blank?
      sentence.fav_count -= 1
      sentence.save
      sentence.chains.each do |chain|
        chain.weight -= 20
        chain.save
      end
    when :follow
      @twitter.follow(event.source)
    end
  end

private

  def generate_sentence
    chains = make_chains
    text = ([chains.first.neck] + chains.map(&:word)).join

    if text.length <= 140
      sentence = Sentence.where(body: text).first_or_initialize
      return nil if sentence.id.present?
      sentence.chains = chains
      sentence.save!
      sentence
    else
      nil
    end
  end

  def make_chains
    chains = []
    chain = Chain.where(head: nil).random_weighted(:weight)
    chains << chain
    while chain = Chain.where(head: chain.neck, neck: chain.word).random_weighted(:weight)
      break if chain.word.nil?
      break if chains.length > 100
      chains << chain
    end
    chains
  end
end
