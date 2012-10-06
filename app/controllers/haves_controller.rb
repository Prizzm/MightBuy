class HavesController < ApplicationController
  layout :choose_layout
  def index
    @haves = current_user.topics.have
    @selected_tab = "ihave"
  end

  def show
    @have = current_user.haves.find_by_shortcode(params[:id])
    @selected_tab = "ihave"
  end

  private
  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end
end
