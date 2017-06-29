class CreateFriendships < ActiveRecord::Migration[5.0]
  def change
    create_table :friendships do |t|
      # create a table having user_id and friend_id(another user as friend)
      t.belongs_to :user
      t.belongs_to :friend, class: 'User'
      t.timestamps
    end
  end
end
