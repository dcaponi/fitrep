class TestController < ApplicationController
  def test
    render json: {response: "yup it works"}
  end
end
