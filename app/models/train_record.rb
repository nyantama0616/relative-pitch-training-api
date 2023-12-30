class TrainRecord < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validate :json_must_be_appropriate_format

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
  def json_must_be_appropriate_format
    begin
      parsed = JSON.parse(json)
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
