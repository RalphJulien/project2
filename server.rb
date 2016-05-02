module Socialmedia

  require 'bcrypt'

  class Server < Sinatra::Base
    enable :sessions


    def current_user
      @current_user ||= conn.exec("SELECT * FROM users WHERE id=#{session[:id]}").first
    end
    # Not exactly sure what this code is doing. I thought it was supposed to keep the current user logged in.

    def logged_in?
      current_user
    end

    # Same goes here.

    get "/" do
      erb :index
    end

    get "/signup" do
      erb :signup
    end

    get "/login" do
      erb :login
    end

    get "/topics" do
      erb :topics
  end

    get "/topics_list" do
      @topics = conn.exec("SELECT * FROM topics")
      erb :topics_list
    end

    get "/posts_list" do
      @posts = conn.exec("SELECT * FROM posts")
      erb :posts_list
    end

    post "/signup" do
      @email = params[:email]
      @password = BCrypt::Password::create(params[:password])

      conn.exec_params(
        "INSERT INTO users (email, password) VALUES ($1, $2)",
        [@email, @password]
      )

      "You have successfully signed up!"

      # redirect "/hacker_backdoor"
    end

    post "/login" do
      @email = params[:email]
      @password = params[:password]

      @user = conn.exec_params(
        "SELECT * FROM users WHERE email=$1 LIMIT 1",
        [@email]
      ).first

      # redirect "/topics"

      if @user && BCrypt::Password::new(@user["password"]) == params[:password]
        "You have successfully logged in!"
        # session[:user_id] = @user["id"]
      else
        "Wrong email or password!"
      end
    end

    post "/topics" do
      @topic_name = params[:topic_name]
      @email = params[:email]
      conn.exec_params(
        "INSERT INTO topics (topic_name, email) VALUES ($1, $2)",
        [@topic_name, @email]
      )


      redirect "/topics_list"
    end

    # get "/#{:topic_name}" do
    #   @topic_name = params[:topic_name]
    #   conn.exec("SELECT text FROM posts WHERE topic_name = #{:topic_name}")
    #   erb :topic_posts
    # end

    get "/posts" do
      erb :posts
    end

    post "/posts" do
      @text = params[:text]
      @topic_name = params[:topic_name]
      @email = params[:email]
      conn.exec_params(
        "INSERT INTO posts (text, topic_name, email) VALUES ($1, $2, $3)",
        [@text, @topic_name, @email]
      )

      redirect "/posts_list"
    end



    # get "/hacker_backdoor" do
    #   @users = conn.exec("SELECT * FROM users")
    #   erb :hacker_backdoor
    # end

    private

    def conn
      PG.connect(dbname: "forum")
    end
  end
end


# Note: using signup lesson from d27_REST_bcrypt as a base
