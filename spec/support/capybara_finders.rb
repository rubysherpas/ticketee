module CapybaraFinders
  def tag(content)
    find("div.tag", text: content)
  end
end
