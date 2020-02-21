# Copyright 2019, Ryan Sise

# This file is part of Podcast Interview Manager.

# Podcast Interview Manager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Podcast Interview Manager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Podcast Interview Manager.  If not, see <https://www.gnu.org/licenses/>.

class ShowsController < ApplicationController

  def new
    if logged_in?
      @host = Host.find(session[:host_id])
      @show = Show.new
    else
      redirect_to root_path
    end
  end

  def create
    if logged_in?
      @host = Host.find(session[:host_id])
      @show = Show.new(show_params)
      if @show.save
        @host.shows << @show
        @host.save
        @show.save
        redirect_to host_path(@host)
      else
        render 'shows/new'
      end
    else
      redirect_to root_path
    end
  end

  def edit
    if logged_in?
      @host = Host.find(session[:host_id])
      @show = Show.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def show
    if logged_in?
      @host = Host.find(session[:host_id])
      @show = Show.find(params[:id])
      @interview = Interview.new
      @interviews = @show.interviews
    else
      redirect_to root_path
    end
  end

  def update
    if logged_in?
      @host = Host.find(session[:host_id])
      @show = Show.find(params[:id])
      @show.update_attributes(show_params)
      redirect_to host_path(@host)
    else
      redirect_to root_path
    end
  end

  def destroy
    if logged_in?
      @host = Host.find(session[:host_id])
      @show = Show.find(params[:id])
      @show.destroy
      redirect_to host_path(@host)
    else
      redirect_to root_path
    end
  end

  private
  def show_params
    params.require(:show).permit(:title, :description, :category, :url, :duration)
  end

end
