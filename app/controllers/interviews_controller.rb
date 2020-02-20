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

class InterviewsController < ApplicationController

  def new
    if logged_in?
      grab_host_show
      @interview = Interview.new
      @guest = Guest.new
    else
      redirect_to root_path
    end
  end

  def create
    if logged_in?
      grab_host_show
      @interview = @show.interviews.new(interview_params)
      @guest = @interview.build_guest(interview_params[:guest_attributes])
      if @guest.save
        @interview.guest = @guest
        if @interview.save
          @show.interviews << @interview
          if @show.save
            redirect_to host_show_path(@host, @show)
          else
            render 'interviews/new'
          end
        else
          render 'interviews/new'
        end
      else
        render 'interviews/new'
      end
    else
      redirect_to root_path
    end
  end

  def show
    if logged_in?
      grab_host_show_int
    else
      redirect_to root_path
    end
  end

  def update
    grab_host_show_int
    @interview.update_attributes(interview_params)
    redirect_to host_show_path(@host, @show)
  end

  def destroy
    if logged_in?
      grab_host_show_int
      @interview.destroy
      redirect_to host_show_path(@host, @show)
    else
      redirect_to root_path
    end
  end

  private
  def interview_params
    params.require(:interview).permit(:date, :start_time, :end_time, :recorded, :published, guest_attributes:[:name, :email, :expertise])
  end

  def grab_host_show
    @host = Host.find(session[:host_id])
    @show = Show.find(params[:show_id])
  end

  def grab_host_show_int
    @host = Host.find(session[:host_id])
    @show = Show.find(params[:show_id])
    @interview = Interview.find(params[:id])
  end
end
