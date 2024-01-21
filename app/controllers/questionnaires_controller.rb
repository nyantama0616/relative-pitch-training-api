

class QuestionnairesController < ApplicationController
  def show
    unless data = Questionnaire.get_questionnaire(params[:name])
      render json: {message: "Questionnaire not found"}, status: :not_found
      return
    end

    render json: {questionnaire: data}
  end

  def create
    unless user = User.find(create_params[:user_id])
      render json: {message: "User not found"}, status: :not_found
      return
    end

    question = Questionnaire.new(create_params)

    unless question.save
      render json: {message: "Failed to create a questionnaire"}, status: :internal_server_error
      return
    end

    render json: {message: "Created a questionnaire"}, status: :created
  end

  private

  def create_params
    {
      user_id: params[:userId],
      name: params[:questionnaireName],
      data: Questionnaire.dumped_data(params[:data]),
    }
  end
end
