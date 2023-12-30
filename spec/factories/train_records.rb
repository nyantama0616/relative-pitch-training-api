NOTES = [50, 52, 53, 55, 57, 59, 62, 64, 65, 67, 69, 71]

FactoryBot.define do
  factory :train_record do |_user_id|
    interval_records = []
    10.times do |i|
        record = {
            note0: 60,
            note1: NOTES.sample,
            missCount: (0..3).to_a.sample,
            duration: 350.step(1000, 10).to_a.sample
        }
        interval_records.push(record)
    end
    
    json { JSON.dump(interval_records) }
    user { create(:user) }
  end
end
