NOTES = [50, 52, 53, 55, 57, 59, 62, 64, 65, 67, 69, 71]

questions = [
  {
    "interval" => {
      "note0" => 60,
      "note1" => 62
    },
    "startTime" => 0,
    "keyPushes" => [
      {
        "note" => 65,
        "time" => 100
      },
      {
        "note" => 62,
        "time" => 500
      },
    ]
  },
  {
    "interval" => {
      "note0" => 60,
      "note1" => 65
    },
    "startTime" => 800,
    "keyPushes" => [
      {
        "note" => 65,
        "time" => 1200
      },
    ]
  },
]

FactoryBot.define do
  factory :train_record do |_user_id|    
    questions { TrainRecord.dumped_questions(questions) }
    user { create(:user) }
  end

  factory :train_record5, class: TrainRecord do |_user_id|
    records = []
    12.times do |i|
      5.times do
        note1 = NOTES[i]
        record = {
            "interval" => {
              "note0" => 60,
              "note1" => note1,
            },
            "startTime" => 0,
            "keyPushes" => [
                {"note" => 45, "time" => 50},
                {"note" => note1, "time" => 100},
            ]
        }
        records.push(record)
      end
    end

    questions { TrainRecord.dumped_questions(records) }
    user { create(:user) }
  end
end
