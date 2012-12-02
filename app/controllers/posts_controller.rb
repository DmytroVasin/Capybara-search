class PostsController < ApplicationController

require 'capybara'
require 'capybara/dsl'
require 'capybara-screenshot'

require 'capybara/poltergeist'

# http://rubular.com/r/mPLks9uNs1

include Capybara::DSL

Capybara.current_driver = :webkit



  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])

    if (@post.search_type == 'http://www.google.com/')
        visit(@post.search_type)
        fill_in "q", :with => @post.query 
        click_button("Google")

        loop_variable = 0
        num_of_page = 1
        max_count_of_page = 4
        flag_on_break = false

        while(loop_variable == 0) do
          has_on_page = page.has_content?(@post.search_question)

          if has_on_page
            loop_variable = 1
          else
            find('.b:last a').click
            num_of_page += 1
          end
          if num_of_page > max_count_of_page
            flag_on_break = true
            break
          end
        end

        page.driver.render(Rails.root.join("app/assets/images/#{@post.id}.png"), :full => true)
        @uri = URI.parse(current_url)

        if flag_on_break
          @number = 'Nothing not found'
        else
          @number = num_of_page
          @post.update_attribute(:fined_query, true)
        end  
    else
      visit(@post.search_type)

      fill_in 'Search', :with => @post.query
      click_button 'Search'

      loop_variable = 0
      num_of_page = 1
      max_count_of_page = 4
      flag_on_break = false

      while(loop_variable == 0) do
        has_on_page = page.has_content?(@post.search_question)

        if has_on_page
          loop_variable = 1
        else
          num_of_page += 1
          click_link 'Next'
        end

        if num_of_page > max_count_of_page
          flag_on_break = true
          break
        end
      end

      page.driver.render(Rails.root.join("app/assets/images/#{@post.id}.png"), :full => true)

      if flag_on_break
        @number = 'Nothing not found'
      else
        @post.update_attribute(:fined_query, true)
        @number = num_of_page
      end  
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    
    if @post.save
      flash[:notice] = "Request is made!"
      redirect_to post_path(@post.id)
    else 
      render 'new'
    end 
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to post_path(@post.id)
    else
      render 'edit'
    end
  end
end
