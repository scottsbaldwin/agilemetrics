require 'trello'

class CardDecorator
  include Trello

  def initialize(card)
    @trello_card = card
  end

  def id
    @trello_card.id
  end

  def number
    @trello_card.short_id
  end

  def name
    @trello_card.name
  end

  def description
    @trello_card.desc
  end

  def url
    @trello_card.url
  end

  def done?
    timeline.done?
  end

  def closed?
    @trello_card.closed
  end

  def actions
    @actions ||= filtered_actions
  end

  def timeline
    @timeline ||= CardTimeline.new(actions)
  end

  private

  def filtered_actions
    @trello_card.actions(filter: "createCard,updateCard:idList,updateCard:closed").map { |action| CardActionDecorator.new(action) }
  end

end
