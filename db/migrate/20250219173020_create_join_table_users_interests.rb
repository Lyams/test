class CreateJoinTableUsersInterests < ActiveRecord::Migration[8.0]
  def change
    create_join_table :users, :interests do |t|
      t.index [ :user_id, :interest_id ]
      t.index [ :interest_id, :user_id ]
    end
  end
end
