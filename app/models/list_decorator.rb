require 'trello'

class ListDecorator
  include Trello
  include TimeHumanizerHelper

  def initialize(list, since)
    @trello_list = list
    @since = since
  end

  def id
    @trello_list.id
  end

  def name
    @trello_list.name
  end

  def cards(filter = {filter: :all})
    filter = {since: @since}.merge(filter)
    @cards ||= @trello_list.cards(filter).map { |card| CardDecorator.new(card) }
  end

  def average_cycle_time
    humanize_seconds(average_cycle_time_in_seconds)
  end

  def average_cycle_time_in_seconds
    if !@_avg_cycle_time
      times = []
      cards.each do |card|
        time_in_list = card.timeline.time_in_list(id)
        times << time_in_list if time_in_list
      end

      if times.size > 0
        @_avg_cycle_time ||= (times.inject(0.0) { |sum, el| sum += el } / times.size).round(0)
      end
    end
    @_avg_cycle_time
  end
end
