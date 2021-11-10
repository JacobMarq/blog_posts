class Api::PostsController < ApplicationController
  require 'rest-client'
  require 'json'
  
  def get_posts
    validity = check_validity

    if validity === "valid"
      url = "https://api.hatchways.io/assessment/blog/posts"
      responses = []
      tags = params[:tags].split(',', -1)

      tags.each do |tag|
        api_response = RestClient.get(url, params: { tag: tag })
        (responses = responses + JSON.parse(api_response)['posts']).uniq!
      end

      sorted_response = sort_response(responses)
      response = response_direction(sorted_response)

      render json: {
        posts: response,
        status: 200
      }
    else
      render json: validity
    end
  end

  private
  
  tag_error = "Tags parameter is required."
  sort_error = "sortBy parameter is invalid"
  direction_error = "direction parameter is invalid"
  error_status = 400

  def posts_params
    params.require(:posts).permit(:tags, :sortBy, :direction)
  end
  
  def check_validity
    if tags_are_present === false
      return {
        error: tag_error,
        status: error_status
      }
    else
      valid_optionals = [sort_is_valid, direction_is_valid]
      
      case valid_optionals
      when valid_optionals[0,1] === false
        return {
          error: sort_error + "\n" + direction_error,
          status: error_status
        }
      when valid_optionals[0] === false
        return {
          error: sort_error,
          status: error_status
        }
      when valid_optionals[1] === false
        return {
          error: direction_error,
          status: error_status
        }
      else
        return "valid"
      end
    end
  end

  def tags_are_present
    if params[:tags].nil?
      return false
    else
      return true
    end
  end

  def sort_is_valid
    valid_sort_requests = ['id', 'popularity', 'reads', 'likes', nil]
    
    params[:sortBy] = 'id' if params[:sortBy].nil?
    valid_sort_requests.include?(params[:sortBy].downcase)
  end

  def direction_is_valid
    valid_direction_requests = ['asc', 'desc', nil]

    params[:direction] = 'asc' if params[:direction].nil?
    valid_direction_requests.include?(params[:direction].downcase)
  end
  
  def sort_response(res)
    identifier = params[:sortBy].downcase unless params[:sortBy].nil?
    
    if identifier.nil? || identifier === 'id' then
      return res.sort_by { |h| h['id'] }
    else
      return res.sort_by { |h| h[identifier] }
    end
  end

  def response_direction(res)
    direction = params[:direction].downcase unless params[:direction].nil?
    
    if direction.nil? || direction === 'asc' then
      return res
    else
      return res.reverse!
    end
  end
end
