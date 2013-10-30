# Attributes used to map a team to a board in Trello
class TrelloAccount < ActiveRecord::Base
  belongs_to :team
end
