class Review
  attr_reader :author,
              :content

  def initialize(attrs)
    @author  = attrs[:author]
    @content = attrs[:content]
  end
end
