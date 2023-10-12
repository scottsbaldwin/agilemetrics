require 'trello'

class CardActionDecorator
  include Trello

  def initialize(action)
    @trello_action = action
  end

  def type
    @trello_action.type
  end

  def date
    @trello_action.date
  end

  def data
    @trello_action.data
  end
end
