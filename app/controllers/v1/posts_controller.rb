class V1::PostsController < ApplicationController
  require 'rest-client'
  require 'json'
  require 'thread'

  def get_posts
    validity = check_validity

    if validity === "valid"
      url = "https://api.hatchways.io/assessment/blog/posts"
      posts = []
      tags = params[:tags].split(',', -1)
      
      #includes threads for parallel requests
      threads = []
      tags.each do |tag|
        threads << Thread.new { 
          response = RestClient.get(url, params: { tag: tag })
          (posts = posts + JSON.parse(response)['posts']).uniq!
        }
      end

      threads.each do |thread|
        thread.join
        puts "#{thread} complete"
      end

      sorted_posts = sort_posts(posts)
      posts = posts_direction(sorted_posts)

      render json: { posts: posts }, status: 200
    else
      render json: validity, status: 400
    end
  end

  private

  def posts_params
    params.require(:posts).permit(:tags, :sortBy, :direction)
  end
  
  def check_validity
    tag_error = "Tags parameter is required."
    sort_error = "sortBy parameter is invalid"
    direction_error = "direction parameter is invalid"

    if tags_are_present === false
      return {
        error: tag_error
      }
    else
      sort = sort_is_valid
      direction = direction_is_valid

      if sort && direction === false then
        return {
          error: sort_error + "\n" + direction_error
        } 
      elsif sort === false then
        return {
          error: sort_error
        }
      elsif direction === false then
        return {
          error: direction_error
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
    return valid_sort_requests.include?(params[:sortBy].downcase)
  end

  def direction_is_valid
    valid_direction_requests = ['asc', 'desc', nil]

    params[:direction] = 'asc' if params[:direction].nil?
    return valid_direction_requests.include?(params[:direction].downcase)
  end
  
  def sort_posts(posts)
    identifier = params[:sortBy].downcase unless params[:sortBy].nil?
    
    if identifier.nil? || identifier === 'id' then
      return posts.sort_by { |h| h['id'] }
    else
      return posts.sort_by { |h| h[identifier] }
    end
  end

  def posts_direction(posts)
    direction = params[:direction].downcase unless params[:direction].nil?
    
    if direction.nil? || direction === 'asc' then
      return posts
    else
      return posts.reverse!
    end
  end
end
