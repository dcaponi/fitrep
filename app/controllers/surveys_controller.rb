class SurveysController < ApplicationController
  before_action :set_survey, only: [:update, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        @surveys = Survey.where(user_id: jwt[:id])
        render json: {surveys: @surveys}, status: :ok
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @survey = Survey
      .where(uuid: params[:uuid])
      # .where("expires_at > ?", Date.today) For now all links are permanent

    unless @survey.empty?
      render json: {surveys: [@survey]}, status: :ok
    else
      render json: {survey: "the requested resource was not found"}, status: :not_found
    end
  end

  # POST /surveys
  # POST /surveys.json
  def create
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        create_params = {}
        create_params[:user_id] = jwt[:id]
        # TODO: Move temporary links over to redis. For now, all links are permanent
        # create_params[:expires_at] = 96.hour.from_now
        @survey = Survey.new(create_params)

        if @survey.save
          render json:  {surveys: [@survey]}, status: :created
        else
          render json: @survey.errors, status: :unprocessable_entity
        end
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        if @survey.update(survey_params)
          render json:  {surveys: [@survey]}, status: :ok
        else
          render json: @survey.errors, status: :unprocessable_entity
        end
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        if @survey
          if @survey.destroy
            render json: @survey, status: :ok
          else
            render json: @survey.errors, status: :unprocessable_entity
          end
        else
          render json: {survey: "The rating link with the given uuid could not be found"}, status: 401
        end
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find_by_uuid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:expires_at)
    end
end
