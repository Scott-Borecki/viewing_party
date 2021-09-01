class Poster
  attr_reader :image

  def initialize(attrs)
    @image = attrs[:file_path]
  end
end
