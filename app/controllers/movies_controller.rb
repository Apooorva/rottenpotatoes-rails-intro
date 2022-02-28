class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
  end
  
  def display_based_rating(ratings,movies)
    ratingArr = Array.new
      if ratings != nil
        ratings.each do |key, value|
         ratingArr.append(key)
       end
      end
      if ratingArr.length() == 0
        return movies,ratingArr
      end
      return movies.where(:rating=>ratingArr) , ratingArr
  end  
    
  def sortFn(sort,movies)
     if sort == 'title'
      sortedMovies = movies.sort_by(&:title)
      session[:sort] = 'title'
      isClick = 'title'
     elsif sort == 'release'
      sortedMovies = movies.sort_by(&:release_date)
      session[:sort] = 'release'
      isClick = 'release'
     else
      sortedMovies = movies
      isClick = 'none'
     end
     return sortedMovies,isClick
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
