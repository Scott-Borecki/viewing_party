class Actor
  attr_reader :name,
              :character

  def initialize(attrs)
    @name      = attrs[:name]
    @character = attrs[:character]
  end
end
