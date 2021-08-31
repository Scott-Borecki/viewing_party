module ApplicationHelper
  def convert_to_hr_min(minutes)
    hr = minutes / 60
    min = minutes % 60
    "#{hr} hr #{min} min"
  end
end
