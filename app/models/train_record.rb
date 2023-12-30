class TrainRecord < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validate :records_must_be_appropriate_format

  class << self
    # params[:records]を渡す
    def dumped_records(records_json)
      json = JSON.dump(records_json)
      json.gsub!(/\\/, "")
      json.gsub!("\"{", "{")
      json.gsub!("}\"", "}")
      json.gsub("=>", ":")
    end
  end

  private

  # 以下のような形式のJSONを想定している
  # [
  #   {
  #     "note0" => 0,
  #     "note1" => 1,
  #     "missCount" => 2,
  #     "duration" => 3,
  #   },
  # ]
  def records_must_be_appropriate_format
    begin
      parsed = JSON.parse(records)
    rescue => exception
      errors.add(:json, "invalid json")
      return
    end

    unless parsed.is_a?(Array)
      errors.add(:json, "json must be an array")
    end

    keys = parsed[0].keys.sort
    expected_keys = %w[note0 note1 missCount duration].sort

    unless keys == expected_keys
      errors.add(:json, "json must be an array of objects with keys: #{expected_keys}")
    end
  end
end
