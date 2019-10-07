class ReplysController < ApplicationController
  def index
    # query replys
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        active_survey = Survey.where(user_id: jwt[:id]).last
        replys = Reply.where(survey_uuid: active_survey.uuid).order(created_at: :desc)
        render json: {replys: replys}, status: 200
      else
        render json: {unauthorized: "invalid credential given"}, status: 401
      end
    else
      render json: {unauthorized: "invalid credential given"}, status: 401
    end
  end

  def show
    # show one reply (useful for comments)
    reply = [Reply.find(params['id'])]
    render json: {replys: reply}, status: 200
  end

  def create
    # create a reply
    ip = request.remote_ip
    create_params = reply_params.to_h
    reply_owner_id = get_survey_owner(create_params["survey_uuid"])
    if reply_owner_id
      create_params['rater_ip'] = ip
      create_params['user_id'] = reply_owner_id
      reply = Reply.new(create_params)
      if reply.save
        render json: {reply: reply.reply, comment: reply.comment}, status: :created
      else
        render json: reply.errors, status: 400
      end
    else
      render json: {survey: "An owner for the given reply link was not found"}, status: 400
    end
  end

  def reply_params
    params.require(:reply).permit(:survey_uuid, :reply, :comment)
  end

  private
  def get_survey_owner(survey_uuid)
    link_entry = Survey.where(uuid: survey_uuid)
    link_entry.first.user_id unless link_entry.empty?
  end
end
