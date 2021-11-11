require 'rails_helper'

RSpec.describe V1::PostsController do
  
  describe 'GET #get_posts' do

    context 'When request fails' do
      context 'due to bad params' do
        before do
          get :get_posts
        end
      
        it 'returns status 400' do
          expect(response.status).to eql(400)
        end

        it 'returns error message' do
          expect(response.body).to include('error')
        end
      end

      context 'due to bad Tags' do
        before do
          get :get_posts
        end

        it 'returns error Tags required' do
          expect(JSON.parse(response.body)['error']).to include('Tags parameter is required.')
        end
      end

      context 'due to bad sortBy or direction parameter' do
        before do
          get :get_posts, params: { tags: 'tech', sortBy: 'fail' }
        end

        it 'returns error sortBy/direction parameter invalid' do
          expect(JSON.parse(response.body)['error']).to include('sortBy parameter is invalid')
        end
      end
    end

    context 'When request is successful' do
      context 'simple request' do
        before do
          get :get_posts, params: { tags: 'tech' }
        end

        it 'returns status 200' do
          expect(response.status).to eql(200)
        end

        it 'returns posts' do
          expect(response.body).to include('posts')
        end
      end

      context 'with multiple tags parameters' do
        before do
          get :get_posts, params: { tags: 'tech,health' }
        end

        it 'returns posts that contain those tags' do
          posts = JSON.parse(response.body)['posts']
          result = posts.any? { |post| post['tags'].include?(['tech', 'health'] === false) }
          
          expect(result).to eql(false)
        end
      end

      context 'with popularity sortBy parameter' do
        before do
          get :get_posts, params: { tags: 'tech', sortBy: 'popularity' }
        end

        it 'returns posts sorted by popularity' do
          posts = JSON.parse(response.body)['posts']
          result = posts.each_cons(2).all?{ |i,j| i['popularity'] <= j['popularity'] }
        
          expect(result).to eql(true)
        end
      end

      context 'with desc direction parameter' do
        before do
          get :get_posts, params: { tags: 'tech', sortBy: 'popularity', direction: 'desc' }
        end

        it 'returns posts sorted in descending order' do
          posts = JSON.parse(response.body)['posts']
          result = posts.each_cons(2).all?{ |i,j| i['popularity'] >= j['popularity'] }
        
          expect(result).to eql(true)
        end
      end
    end

  end
end
