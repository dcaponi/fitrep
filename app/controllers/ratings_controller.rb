class RatingsController < ApplicationController
  def index
    # query ratings
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        ratings = Rating.where(user_id: jwt[:id])
        render json: {ratings: ratings}, status: 200
      else
        render json: {unauthorized: "invalid credential given"}, status: 401
      end
    else
      render json: {unauthorized: "invalid credential given"}, status: 401
    end
  end

  def show
    # show one rating (useful for comments)
    rating = [Rating.find(params['id'])]
    render json: {ratings: rating}, status: 200
  end

  def create
    # create a rating
    ip = request.remote_ip
    create_params = rating_params.to_h
    create_params['rater_ip'] = ip
    rating = Rating.new(create_params)
    if rating.save
      render json: {rating: rating.rating, comment: rating.comment}, status: :created
    else
      render json: rating.errors, status: 401
    end

  end

  def rating_params
    params.require(:rating).permit(:user_id, :rating, :comment)
  end
end
