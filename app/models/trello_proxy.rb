require 'trello'

class TrelloProxy
  include Trello

  LIST = Struct.new(:id, :name, :list)
  CARD = Struct.new(:id, :name, :list_id, :card)

  attr_accessor :lists, :cards
  def self.create(public_key, member_token, board_id)
    new(public_key, member_token, board_id)
  end

  def initialize(public_key, member_token, board_id)
    @trello_public_key = public_key
    @trello_member_token = member_token
    @board_id = board_id
    configure_trello
    self
  end

  def board
    @board ||= BoardDecorator.for(@board_id)
  end

  def debug=(is_debug)
    @debug = is_debug
  end

  def debug?
    @debug
  end

  # def show_lists_on_board
  #   require_lists
  #   tp @lists.map {|k,v| v}
  # end

  # def show_cards_on_board
  #   require_cards
  #   tp @cards.map {|k,v| v}
  # end

  # def show_cards_in_list(list_id)
  #   list = List.find(list_id)
  #   cards = []
  #   list.cards.each do |card|
  #     cards << CARD.new(card.id, card.name)
  #   end
  #   tp cards
  # end

  # def list_closed_cards_on_board(board_id)
  #   board = Board.find(board_id)
  #   cards = board.cards({
  #     :filter => :closed
  #   })

  #   ages = []
  #   cards.each do |card|
  #     # Only hit the API once to get both actions
  #     actions = card.actions({ :filter => "createCard,updateCard:closed" })

  #     # Grab the creation date
  #     creation_date = actions.find {|a| a.type == "createCard" }
  #     closed_date = actions.find {|a| a.type == "updateCard" && a.data["card"]["closed"] && !a.data["old"]["closed"] }

  #     if creation_date && closed_date
  #       age = age_in_days(closed_date.date - creation_date.date)
  #       ages << age
  #       puts "#{card.id}\t\t#{age.round} day(s) old"
  #     end
  #   end

  #   sum = ages.inject(0.0) { |sum, el| sum += el }
  #   mean = sum.to_f / ages.size
  #   puts "\n\nAverage Cycle Time from Creation to Closed: #{mean.round}"
  # end

  private

  def configure_trello
    Trello.configure do |config|
      config.developer_public_key = @trello_public_key
      config.member_token = @trello_member_token
    end
  end

  # def require_lists
  #   @lists ||= load_lists
  # end

  # def load_lists
  #   lists = {}
  #   board.lists.each do |list|
  #     lists[list.id] = LIST.new(list.id, list.name, list)
  #   end
  #   lists
  # end

  # def require_cards
  #   require_lists
  #   @cards ||= load_cards
  # end

  # def load_cards
  #   cards = {}
  #   @lists.each do |list_id, value|
  #     debug("Loading cards for list #{value.list.name} (#{list_id})")
  #     value.list.cards.each do |card|
  #       cards[card.id] = CARD.new(card.id, card.name, list_id, card)
  #     end
  #   end
  #   cards
  # end

  def age_in_days seconds
    minute = 60
    hour = 60 * minute
    day = 24 * hour
    seconds / day
  end

  def debug(msg)
    puts msg if debug?
  end

end
