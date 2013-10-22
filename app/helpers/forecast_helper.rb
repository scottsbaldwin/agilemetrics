module ForecastHelper
  def size_of_card(card)
    name = card.name
    r = /^\((?<estimate>\d+\.?\d*)\)/
    return '?' unless name =~ r
    m = r.match(name)
    m["estimate"].to_f
  end
end
