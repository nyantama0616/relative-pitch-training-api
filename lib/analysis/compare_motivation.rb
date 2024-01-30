require_relative './users.rb'
require_relative './datum.rb'
require_relative './util.rb'
require_relative './guessed_times.rb'

shimamuras = $users[:shimamura].filter { |user| user.train_records.length == 6 }
systems = $users[:system].filter { |user| user.train_records.length == 11 }

user = systems[0]

puts "===システム群==="
system_ratio = systems.map do |user|
  system_train_times = 5.times.to_a.map do |i|
    train = user.nth_train(i)
    train.train_time / 1000.0
  end

  guessed_train_times = $guessed_times[user.id]

  ratio = 5.times.to_a.map do |i|
    guessed = guessed_train_times[i] * 60
    guessed / system_train_times[i]
  end

  p ratio
  puts ""

  (ratio.sum / ratio.length).round(3)
end

puts "===島村群==="
shimamura_ratio = shimamuras.map do |user|
  guessed_train_times = $guessed_times[user.id]
  ratio = 5.times.to_a.map do |i|
    guessed = guessed_train_times[i] * 60
    guessed / 600.0
  end

  p ratio
  puts ""

  (ratio.sum / ratio.length).round(3)
end

puts "===システム群==="
p system_ratio
puts "中央値: #{Util.median(system_ratio)}"
puts "平均値: #{system_ratio.sum / system_ratio.length}"
puts ""

puts "===島村群==="
p shimamura_ratio
puts "中央値: #{Util.median(shimamura_ratio)}"
puts "平均値: #{shimamura_ratio.sum / shimamura_ratio.length}"
