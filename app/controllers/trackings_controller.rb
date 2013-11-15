class TrackingsController < ApplicationController
  def update
    params.each {|p| puts p}
    redirect_to :back
  end
end
