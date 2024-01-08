class TrainRecord < ApplicationRecord
  include Analysis

  belongs_to :user
  validates :user_id, presence: true
  validate :questions_must_be_appropriate_format

  def info
    {
      id: id,
      userId: user_id,
      questions: TrainRecord.parsed_questions(questions),
    }
  end

  class << self
    def dumped_questions(questions_json)
      json = JSON.dump(questions_json)
      json.gsub!(/\\/, "")
      json.gsub!("\"{", "{")
      json.gsub!("}\"", "}")
      json.gsub("=>", ":")
    end

    def parsed_questions(questions_dumped)
      JSON.parse(questions_dumped)
    end
  end

  private

  def questions_must_be_appropriate_format
    begin
      parsed = TrainRecord.parsed_questions(questions)
    rescue => exception
      errors.add(:json, "invalid json")
      return
    end

    unless parsed.is_a?(Array)
      errors.add(:json, "json must be an array")
    end

    #TODO: もう少しデータ構造を厳密にチェックしたい
    keys = parsed[0].keys.sort
    expected_keys = %w[interval startTime keyPushes].sort

    unless keys == expected_keys
      errors.add(:json, "json must be an array of objects with keys: #{expected_keys}")
    end
  end
end
