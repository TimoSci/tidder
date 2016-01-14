module Peckable

  def back_distance(target)
    return 0 if target == self
    distance = 0
    cursor = self
    until cursor == target do
      cursor = cursor.predecessor
      return nil if not cursor
      distance -= 1
    end
    distance
  end

  def distance(target)
    if b = self.back_distance(target)
      b
    elsif d = target.back_distance(self)
      -d
    else
      nil
    end
  end

  def <=> (target)
    d = self.distance(target)
    if not d
      0
    elsif d > 0
      -1
    else
      1
    end
  end

end
