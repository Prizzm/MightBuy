module Topic::Have
  def human_status
    ihave? ? "has" : "mightbuy"
  end

  def ihave?
    status == "ihave"
  end
end
