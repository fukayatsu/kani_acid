every 2.hours do
  rake "kani:lean"
end

every 10.minutes do
  rake "kani:tweet"
end
