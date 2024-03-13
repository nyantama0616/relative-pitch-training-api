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

  def dump
    dir = "tmp/train_record"
    Dir.mkdir(dir) unless Dir.exist?(dir)

    File.open("#{dir}/#{self.id}.json", "w") do |f|
      f.write(questions)
    end
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

    def create_from_json_file(path, user)
      src = "db/json/train_record/#{path}"
      json = File.read(src)
      json.gsub!(" ", "")
      json.gsub!("\r", "")
      json.gsub!("\n", "")
      create(questions: json, user: user)
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
