class Poster
  attr_reader :image

  def initialize(attrs)
    @image = "https://image.tmdb.org/t/p/w500#{attrs[:file_path]}"
  end
end
