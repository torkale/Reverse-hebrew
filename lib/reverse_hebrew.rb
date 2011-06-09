# coding: utf-8

# A module to reverse visual Hebrew text into logical Hebrew text
module ReverseHebrew

  def self.is_hebrew?(s)
    m = s=~ /[א-ת]/
    not m.nil?
  end

  def self.is_left_alone?(c)
    m = c=~ /[a-zA-Z0-9\-\/]/
    not m.nil?
  end

  def self.rev_special(c)
    pairs = '{}<>[]()'
    pos = pairs.index(c)
    return c unless pos
    pairs[pos^1]
  end

  def self.reverse_hebrew(s)
    return s unless is_hebrew?(s)
    heb = []
    temp = []
    # Go over the string except for the last char
    (0...(s.length-1)).each do |i|
      c = rev_special(s[i])
      # Checking if this char and the next one are special
      if is_left_alone?(c) and is_left_alone?(s[i + 1])
        temp << c
      elsif is_left_alone?(c)
        # If the next char is not special, we pop the temp stack into the Hebrew stack
        temp << c
        heb << temp.pop while not temp.empty?
      else
        heb << c
      end
    end
    # Now handle the last char
    c = s[-1]
    if is_left_alone?(c)
      temp << c
    else
      heb << c
      heb << temp.pop while not temp.empty?
    end
    # Build and return result string
    heb.reverse * ''
  end

  def self.correct_special(target, reference, chars)
    chars.each_char do |c|
      target.insert(0, c) if reference[-1] == c
      target << c if reference[0] == c
    end
    target
  end

  def self.reverse_around_number(s)
    pattern = /[א-ת].+[א-ת]/
    heb = s[pattern]
    non_heb = s.gsub pattern, ""
    reversed = non_heb.split(/[ \.]/).reverse * " "
    correct_special(reversed, non_heb, ". ")
    heb << reversed
  end

end

