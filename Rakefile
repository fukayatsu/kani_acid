require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

require './kani'

namespace :kani do
  desc 'lean words from search'
  task :lean do
    Kani.new.lean_from_search
    Kani.new.lean_from_timeline
  end

  desc 'tweet something'
  task :tweet do
    Kani.new.tweet_something
  end
end