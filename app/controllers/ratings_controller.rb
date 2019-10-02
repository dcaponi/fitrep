class RatingsController < ApplicationController
  def index
    # query ratings
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        active_rating_link = RatingLink.where(user_id: jwt[:id]).last
        ratings = Rating.where(rating_link_uuid: active_rating_link.uuid).order(created_at: :desc)
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
    rating_owner_id = get_rating_link_owner(create_params["rating_link_uuid"])
    if rating_owner_id
      create_params['rater_ip'] = ip
      create_params['user_id'] = rating_owner_id
      rating = Rating.new(create_params)
      if rating.save
        render json: {rating: rating.rating, comment: rating.comment}, status: :created
      else
        render json: rating.errors, status: 400
      end
    else
      render json: {rating_link: "An owner for the given rating link was not found"}, status: 400
    end
  end

  def rating_params
    params.require(:rating).permit(:rating_link_uuid, :rating, :comment)
  end

  private
  def get_rating_link_owner(rating_link_uuid)
    link_entry = RatingLink.where(uuid: rating_link_uuid)
    link_entry.first.user_id unless link_entry.empty?
  end
end
