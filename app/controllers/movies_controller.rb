class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @movies = Movie.all
    if params[:sort_by] == "title"
      session[:sort_by] = "title"
    elsif params[:sort_by] == "release_date"
      session[:sort_by] = "date"
    end

    if session[:sort_by] == "title"
       @movies = Movie.order("title")
       @col = "title"
    elsif session[:sort_by] == "date"
       @movies = Movie.order("release_date")
       @col = "date"
    else
       @movies = Movie.all
    end
    checked_keys = Array.new
    if !(params[:ratings].nil?)
      session[:ratings] = params[:ratings]
    end
    if session[:ratings]
      checked_keys << session[:ratings].keys
      filtered_movie_list = Array.new
      @movies.each do |movie|
        if checked_keys.include? movie[:rating]
          filtered_movie_list << movie
        end
      end
      @movies = filtered_movie_list
    end
    # if(params[:sort_by] == nil && params[:ratings] == nil)
    #   if(session[:sort_by] || session[:ratings])
    #     redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    #   end
    # end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
