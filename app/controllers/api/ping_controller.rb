class Api::PingController < ApplicationController
  def ping_api
    url = "https://api.hatchways.io/assessment/blog/posts?tag=[]"
    response = RestClient.get(url)
    if response
      render json: {
        success: true,
        status: response.code 
      }
    else
      render json: {
        success: false,
        status: response.code
      }
    end
  end
end
