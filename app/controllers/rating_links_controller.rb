class RatingLinksController < ApplicationController
  before_action :set_rating_link, only: [:update, :destroy]

  # GET /rating_links
  # GET /rating_links.json
  def index
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        @rating_links = RatingLink.where(user_id: jwt[:id])
        render json: {rating_links: @rating_links}, status: :ok
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  # GET /rating_links/1
  # GET /rating_links/1.json
  def show
    @rating_link = RatingLink
      .where(uuid: params[:uuid])
      # .where("expires_at > ?", Date.today) For now all links are permanent

    unless @rating_link.empty?
      render json: {rating_links: [@rating_link]}, status: :ok
    else
      render json: {rating_link: "the requested resource was not found"}, status: :not_found
    end
  end

  # POST /rating_links
  # POST /rating_links.json
  def create
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        create_params = {}
        create_params[:user_id] = jwt[:id]
        # TODO: Move temporary links over to redis. For now, all links are permanent
        # create_params[:expires_at] = 96.hour.from_now
        @rating_link = RatingLink.new(create_params)

        if @rating_link.save
          render json:  {rating_links: [@rating_link]}, status: :created
        else
          render json: @rating_link.errors, status: :unprocessable_entity
        end
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  # PATCH/PUT /rating_links/1
  # PATCH/PUT /rating_links/1.json
  def update
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        if @rating_link.update(rating_link_params)
          render json:  {rating_links: [@rating_link]}, status: :ok
        else
          render json: @rating_link.errors, status: :unprocessable_entity
        end
      else
        render json: {invalid_credential: "invalid credential given"}, status: 401
      end
    else
      render json: {no_credential: "no credential given"}, status: 401
    end
  end

  # DELETE /rating_links/1
  # DELETE /rating_links/1.json
  def destroy
    if cookies[:login]
      jwt = JsonWebToken.decode(cookies[:login])
      if jwt
        if @rating_link
          if @rating_link.destroy
            render json: @rating_link, status: :ok
          else
            render json: @rating_link.errors, status: :unprocessable_entity
          end
        else
          render json: {rating_link: "The rating link with the given uuid could not be found"}, status: 401
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
    def set_rating_link
      @rating_link = RatingLink.find_by_uuid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_link_params
      params.require(:rating_link).permit(:expires_at)
    end
end
