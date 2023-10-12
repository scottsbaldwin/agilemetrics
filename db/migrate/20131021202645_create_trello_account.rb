class CreateTrelloAccount < ActiveRecord::Migration
  def change
    create_table :trello_accounts do |t|
      t.string :public_key
      t.string :read_token
      t.string :board_id
      t.string :list_name_for_backlog
      t.belongs_to :team, index: true
    end
  end
end
