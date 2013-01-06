
class String
  def ucwords
    self.split(' ').select {|w| w.capitalize! || w }.join(' ')
  end
end
