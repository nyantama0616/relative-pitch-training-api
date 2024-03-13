require 'csv'
require 'fileutils'

class Questionnaire < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :name
    validates :user_id
    validates :data
  end

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

    def create_from_json_file(path)
      src = "db/json/questionnaire/#{path}"
      json = JSON.parse(File.read(src))
      user = User.find_by(user_name: json["user_name"])
      Questionnaire.create(name: json["name"], user: user, data: json["data"])
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

  def compare(other)
    raise "name mismatch" if other.name != self.name

    parsed = Questionnaire.parsed_data(self.data)
    other_parsed = Questionnaire.parsed_data(other.data)

    res = ""
    parsed.length.times do |i|
      raise "content mismatch" if parsed[i]["content"] != other_parsed[i]["content"]

      puts "#{parsed[i]["content"]}: #{parsed[i]["answer"]} => #{other_parsed[i]["answer"]} \n"
    end

    # group = self.user.shimamura? ? "島村" : "システム"

    # text_before = <<~TEXT
    #   \\begin{table}[htb]
    #   \\centering
    #   \\caption{トレーニングのモチベーションを問うためのアンケート #{group}群 被験者#{user.subname} 回答結果(1日目)}
    #   \\label{q:モチベーション#{group}結果#{user.subname}}
    #   \\begin{tabular}{@{}|p{10cm}|p{2cm}|p{2cm}|l|@{}}
    #   \\hline
    #   質問 & 1日目回答結果 & 5日目回答結果 \\\\
    #   \\hline
    #   \\noalign{\\smallskip}
    #   \\hline
    # TEXT

    # text_medium = ""

    # parsed.length.times do |i|
    #   raise "content mismatch" if parsed[i]["content"] != other_parsed[i]["content"]

    #   text_medium += "#{parsed[i]["content"]} & #{parsed[i]["answer"]} & #{other_parsed[i]["answer"]} \\\\ \\hline\n"  
    # end

    # text_after = <<~TEXT
    #   \\end{tabular}
    #   \\end{table}
    # TEXT

    # File.open("tmp/result.tex", "w") do |file|
    #   res = text_before + text_medium + text_after
    #   file.write(res)
    # end
  end

  def output
    parsed = Questionnaire.parsed_data(self.data)
    group = self.user.shimamura? ? "島村" : "システム"

    text_before = <<~TEXT
      \\begin{table}[htb]
      \\centering
      \\caption{トレーニングのモチベーションを問うためのアンケート #{group}群 被験者#{user.subname} 回答結果}
      \\label{q:モチベーション#{group}結果#{user.subname}}
      \\begin{tabular}{@{}|p{8cm}|p{3cm}|l|@{}}
      \\hline
      質問 & 回答結果 \\\\
      \\hline
      \\noalign{\\smallskip}
      \\hline
    TEXT

    text_medium = ""
  
    parsed.length.times do |i|
      next if parsed[i]["content"] == "出身地"
      text_medium += "#{parsed[i]["content"]} & #{parsed[i]["answer"]} \\\\ \\hline\n"
    end

    text_after = <<~TEXT
      \\end{tabular}
      \\end{table}
    TEXT

    File.open("tmp/result.tex", "w") do |file|
      res = text_before + text_medium + text_after
      file.write(res)
    end
  end

  def expected_train_time
    raise "not motivation questionnaire" if self.name != "motivation"

    parsed = Questionnaire.parsed_data(self.data)
    res = parsed[0]["answer"][/\d+/].to_i
  end

  def music_experience
    raise "not attribute questionnaire" if self.name != "attribute"

    parsed = Questionnaire.parsed_data(self.data)
    res = parsed[4]["answer"]
  end

  def dump
    dir = "tmp/questionnaire"
    Dir.mkdir(dir) unless Dir.exist?(dir)

    File.open("#{dir}/#{self.id}.json", "w") do |f|
      user_name = self.user.user_name
      f.write(JSON.dump({name: self.name, user_name: user_name, data: self.data}))
    end
  end
end
