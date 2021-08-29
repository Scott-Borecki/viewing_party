class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: params[:friend_email])
    if friend.present?
      Friendship.create(followee_id: friend.id, follower_id: current_user.id)
      current_user.reload

      redirect_to URI(request.referer).path # redirect back to the path you came from
    else
      flash[:error] = 'User does not exist.'
      
      redirect_to URI(request.referer).path
    end
  end
end
