require 'csv'
require 'fileutils'

class Questionnaire < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :user_id
    validates :data
  end

  validate :data_must_not_be_empty

  before_save :save_data

  class << self
    def get_questionnaire(name)
      file_path = "app/assets/questionnaire/#{name}.csv"

      begin
        csv_data = CSV.read(file_path, headers: true, encoding: "UTF-8")
      rescue => exception
        return
      end

      csv_data.map(&:to_h)
    end

    def dumped_data(data)
      json = JSON.dump(data)
      json.gsub!(/\\/, "")
      json.gsub!("\"{", "{")
      json.gsub!("}\"", "}")
      json.gsub("=>", ":")
    end

    def parsed_data(data_dumped)
      JSON.parse(data_dumped)
    end
  end

  def output_file
    dir = "tmp/#{Rails.env}/questionnaire"
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
    file_path = "#{dir}/#{self.id}.csv"
    
    parsed = Questionnaire.parsed_data(self.data)
    
    CSV.open(file_path, 'w') do |csv|
      csv << parsed.first.keys
      parsed.each do |hash|
        csv << hash.values
      end
    end
  end

  private

  def data_must_not_be_empty
    errors.add(:data, "can't be empty") if data.blank?
  end

  def save_data
    self.data_file_path = Questionnaire.last ? Questionnaire.last.id + 1 : 1 #TODO: 要改善
  end
end
