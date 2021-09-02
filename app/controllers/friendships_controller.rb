class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: params[:friend_email])
    if friend.present?
      Friendship.create(followee_id: friend.id, follower_id: current_user.id)
      current_user.reload # Check if this was only needed in test environment
    else
      flash[:danger] = 'User does not exist.'
    end

    redirect_to URI(request.referer).path
  end
end
