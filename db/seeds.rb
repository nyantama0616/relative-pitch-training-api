# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

NOTES = [50, 52, 53, 55, 57, 59, 62, 64, 65, 67, 69, 71]
interval_records = []
100.times do |i|
    record = {
        note0: 60,
        note1: NOTES.sample,
        missCount: (0..3).to_a.sample,
        duration: 350.step(1000, 10).to_a.sample
    }
    interval_records.push(record)
end

TrainRecord.create(json: JSON.dump(interval_records))
