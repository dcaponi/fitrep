class RatingLinksController < ApplicationController
  before_action :set_rating_link, only: [:update, :destroy]

  # GET /rating_links
  # GET /rating_links.json
  def index
    # @rating_links = RatingLink.all
  end

  # GET /rating_links/1
  # GET /rating_links/1.json
  def show
    @rating_link = RatingLink
      .where("expires_at > ?", Date.today)
      .where(uuid: params[:uuid])
      
    render json: @rating_link, status: :ok
  end

  # POST /rating_links
  # POST /rating_links.json
  def create
    create_params = rating_link_params
    create_params[:expires_at] = 96.hour.from_now
    @rating_link = RatingLink.new(create_params)

    if @rating_link.save
      render json: @rating_link, status: :created
    else
      render json: @rating_link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rating_links/1
  # PATCH/PUT /rating_links/1.json
  def update
    if @rating_link.update(rating_link_params)
      render json: @rating_link, status: :ok
    else
      render json: @rating_link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rating_links/1
  # DELETE /rating_links/1.json
  def destroy
    @rating_link.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating_link
      @rating_link = RatingLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_link_params
      params.require(:rating_link).permit(:user_id, :expires_at)
    end
end
