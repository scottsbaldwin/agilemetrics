# Wrapper for a Trello Board to provide additional functionality
require 'trello'

class BoardDecorator
  include Trello
  include TimeHumanizerHelper

  def self.for(board_id, since = nil)
    b = Board.find(board_id)
    BoardDecorator.new(b, since)
  end

  def initialize(board, since = nil)
    @trello_board = board
    @since = since
  end

  def board_id
    @trello_board.id
  end

  def since
    @since
  end

  def since=(since)
    @since = since
  end

  def list_ids
    lists.keys
  end

  def list_by_id(list_id)
    lists[list_id]
  end

  def list_starts_with(prefix)
    l = lists.select { |k, v| v.name =~ /^#{prefix}/i }
    l[l.keys.first]
  end

  def cycle_times_for_lists
    lists.each do |list_id, list|
      puts "#{list.name}: #{list.average_cycle_time}"
    end
    nil
  end

  def average_lead_time
    times = []
    lists.each do |list_id, list|
      done_or_closed_cards = list.cards.select do |c|
        c.timeline.done? || c.timeline.closed?
      end
      times.concat done_or_closed_cards.map { |c| c.timeline.age_in_seconds }
    end
    puts "Average lead time: #{humanize_seconds(average(times))}"
  end

  private

  def average(values)
    avg = 0.0
    if values.size > 0
      avg = (values.reduce(0.0) { |a, e| a + e } / values.size).round(0)
    end
    avg
  end

  def lists
    @lists ||= list_hash
  end

  def list_hash
    mapping = {}
    @trello_board.lists.each do |list|
      mapping[list.id] = ListDecorator.new(list, @since)
    end
    mapping
  end
end
