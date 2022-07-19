class ViewingPartyController < ApplicationController

  def new
    @movie = MovieFacade.movie_id_search(params[:id])
    @movie_id = params[:id]
    @user_id = current_user.id
    @users = User.all
  end

  def create
    users = User.all
    host_id = current_user.id
    movie = MovieFacade.movie_id_search(params[:id])

    if params[:duration].to_i < movie.runtime.to_i
      flash[:notice] = "Please enter a duration that is longer than the movie runtime"
      redirect_to("/movies/#{movie.id}/viewing_party/new")
    else
      viewing_party = ViewingParty.create!(movie_id: params[:id],
                                            duration: params[:duration],
                                            date: "#{params['date(1i)']}-#{params['date(2i)']}-#{params['date(3i)']}",
                                            start_time: "#{params['start_time(4i)']}:#{params['start_time(5i)']}")
      users.each do |user|
        if host_id != user.id && params[user.name.to_sym] == '1'
          UserViewingParty.create!(user_id: user.id, viewing_party_id: viewing_party.id, host: false)
        elsif host_id == user.id
          UserViewingParty.create!(user_id: host_id, viewing_party_id: viewing_party.id, host: true)
        end
      end
      redirect_to '/dashboard'
    end
  end
end
