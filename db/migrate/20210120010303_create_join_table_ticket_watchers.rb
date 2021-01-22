class CreateJoinTableTicketWatchers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :tickets, :users, table_name: :ticket_watchers do |t|
      t.index [:ticket_id, :user_id], unique: true
      t.index [:user_id, :ticket_id]
    end
  end
end
