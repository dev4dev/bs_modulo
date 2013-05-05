
class Hook
  
  def initialize
    @hooks = {}
  end
  
  def add name, code
    unless code.is_a?(Proc)
      false
    end
    @hooks[name] ||= []
    @hooks[name] << code
  end
  
  def fire name, params={}
    hooks = @hooks[name] || []
    hooks.each do |code|
      code.call params
    end
  end
  
end

# Example
# h = Hook.new
# h.add :start, proc {|config| puts "starting... #{config}"}
# h.add :start, proc {|config| puts "Hello #{config[:name]}!"}
# h.fire :start, :name => "world"
