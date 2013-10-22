class CardTimeline
  include TimeHumanizerHelper

  def initialize(actions)
    @actions = actions || []
    assemble_timeline
  end

  def print
    @actions.reverse.each do |action|
      puts "#{action.date}\t\t#{action.type}"
    end
  end

  def creation_date
    if @actions.size > 0
      @actions.last.date
    else
      nil
    end
  end

  def done?
    !last_done_action.nil?
  end

  def done_date
    a = last_done_action
    a ? a.date : nil
  end

  def closed?
    !closed_date.nil?
  end

  def closed_date
    action = @actions.detect {|a| a.type =~ /updateCard/i && a.data["old"].has_key?("closed")}
    action ? action.date : nil
  end

  def age
    humanize_seconds age_in_seconds
  end

  def age_in_seconds
    if @_age
      @_age
    else
      seconds = 0
      if done?
        seconds = calculate_age_in_seconds(creation_date, done_date)
      elsif closed?
        seconds = calculate_age_in_seconds(creation_date, closed_date)
      elsif creation_date
        seconds = calculate_age_in_seconds(creation_date, Time.now)
      end
      @_age ||= seconds
    end
  end

  def time_in_lists
    @_seconds_in_list
  end

  def time_in_list(list_id)
    @_seconds_in_list.has_key?(list_id) ? @_seconds_in_list[list_id][:seconds_in_list] : 0
  end

  private

  def assemble_timeline
    @_seconds_in_list = {}

    # walk the actions and build an easier data structure to work with
    events = []
    @actions.reverse.each_with_index do |action, index|
      before_list = list_before_current_index(index)
      after_list = list_from_result_of_action(action)
      seconds = time_since_last_action(index)

      list_identifier = before_list["id"]
      if list_identifier
        if !@_seconds_in_list.has_key?(list_identifier)
          @_seconds_in_list[list_identifier] = {
            list_id: before_list["id"],
            list_name: before_list["name"],
            seconds_in_list: 0
          }
        end
        @_seconds_in_list[list_identifier][:seconds_in_list] += seconds
      end

      if index == @actions.length - 1
        # we won't have an after_list if the card was closed after being
        # created and left in a single list
        if after_list
          list_identifier = after_list["id"]
          if !@_seconds_in_list.has_key?(list_identifier)
            @_seconds_in_list[list_identifier] = {
              list_id: after_list["id"],
              list_name: after_list["name"],
              seconds_in_list: 0
            }
          end

          seconds = 0
          if done?
            seconds = calculate_age_in_seconds(action.date, done_date)
          elsif closed?
            seconds = calculate_age_in_seconds(action.date, closed_date)
          else
            seconds = calculate_age_in_seconds(action.date, Time.now)
          end
          @_seconds_in_list[list_identifier][:seconds_in_list] += seconds
        end
      end


    end

  end

  def list_before_current_index(current_index)
    if current_index == 0
      "?"
    else
      list = nil
      current_index.downto(1) do |i|
        list = list_from_result_of_action(@actions.reverse[i - 1])
        break if list
      end
      list
    end
  end

  def list_from_result_of_action(action)
    if action.type == "createCard"
      action.data["list"]
    elsif action.type == "updateCard" && action.data.has_key?("old") && action.data["old"].has_key?("idList")
      action.data["listAfter"]
    end
  end

  def time_since_last_action(current_index)
    if current_index == 0
      0
    else
      actions = @actions.reverse
      current_date = actions[current_index].date
      previous_date = actions[current_index - 1].date
      (current_date - previous_date).round(0)
    end
  end

  def last_done_action
    @_last_done_action = @actions.detect { |a| a.type =~/updateCard/ && a.data.has_key?("listAfter") && a.data["listAfter"].has_key?("name") && a.data["listAfter"]["name"] =~ /Done/i }
  end

  def calculate_age_in_seconds(start_time, end_time)
    (end_time - start_time).round(0)
  end

  def age_in_hours seconds
    minute = 60
    hour = 60 * minute
    seconds / hour
  end

  def age_in_days seconds
    minute = 60
    hour = 60 * minute
    day = 24 * hour
    seconds / day
  end
end
