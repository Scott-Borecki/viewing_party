class EventsController < ApplicationController
  def new
    @event = Event.new
    @movie = MovieFacade.search_by_id(params[:movie_id])
  end

  def create
    params[:date_time] = DateTime.civil(
      params[:date]['when(1i)'].to_i,
      params[:date]['when(2i)'].to_i,
      params[:date]['when(3i)'].to_i,
      params[:time]['start_time(4i)'].to_i,
      params[:time]['start_time(5i)'].to_i
    )
    new_event = current_user.events.create(event_params)
    if new_event.save
      params['invitations'].each do |email, value|
        next unless value == '1'

        user = User.find_by(email: email)
        new_event.invitations.create!(user: user)
      end

      redirect_to dashboard_path
    else
      flash[:error] = "Error: #{error_message(new_event.errors)}"
      redirect_to URI(request.referer).path
    end
  end

  private

  def event_params
    params.permit(:movie_id, :date_time, :duration)
  end
end
