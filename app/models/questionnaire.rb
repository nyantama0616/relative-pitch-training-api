require 'csv'
require 'fileutils'

class Questionnaire < ApplicationRecord
  attr_accessor :data

  with_options presence: true do
    validates :name
    validates :user_id
  end

  validate :data_must_not_be_empty

  before_save :save_data
  before_destroy :destroy_data

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
  end

  private

  def data_must_not_be_empty
    errors.add(:data, "can't be empty") if data.blank?
  end

  def save_data
    self.data_file_path = Questionnaire.last ? Questionnaire.last.id + 1 : 1 #TODO: 要改善
    
    dir = "storage/#{Rails.env}/questionnaire"
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
    file_path = "#{dir}/#{self.data_file_path}.csv"
    
    CSV.open(file_path, 'w') do |csv|
      csv << data.first.keys
      data.each do |hash|
        csv << hash.values
      end
    end
  end

  def destroy_data
    file_path = "storage/#{Rails.env}/questionnaire/#{self.data_file_path}.csv"
    FileUtils.rm(file_path) if File.exist?(file_path)
  end
end
