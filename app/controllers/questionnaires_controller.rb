require 'csv'

class QuestionnairesController < ApplicationController
  def show
    file_path = "app/assets/questionnaire/#{params[:name]}.csv"

    begin
      csv_data = CSV.read(file_path, headers: true, encoding: "UTF-8")
    rescue => exception
      render json: {message: "Questionnaire not found"}, status: :not_found
      return
    end
    
    data = csv_data.map(&:to_h)

    render json: {questionnaire: data}
  end
end
