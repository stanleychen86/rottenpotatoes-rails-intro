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
    @all_ratings = Movie.all_ratings
    @targetColumn = params[:sort_by]
    
    if params[:sort_by].nil? && params[:ratings].nil?
      if (!session[:sort_by].nil? || !session[:ratings].nil?)
        flash.keep
        redirect_to movies_path(:sort_by=>session[:sort_by], :ratings=>session[:ratings])
      end
    else
      session[:ratings] = params[:ratings]
      session[:sort_by] = params[:sort_by]
    end

    @selected_ratings = (params[:ratings].keys if !params[:ratings].nil?) || @all_ratings

    @movies = Movie.where(rating: @selected_ratings).order(params[:sort_by])
    
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
