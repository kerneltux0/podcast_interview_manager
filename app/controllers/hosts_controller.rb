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

class HostsController < ApplicationController

  def new
    @host = Host.new
  end

  def create
    @host = Host.new(host_params)
    if @host.save
      redirect_to '/login'
    else
      render 'hosts/new'
    end
  end

  def show
    if logged_in?
      grab_host
      @shows = @host.shows
    else
      redirect_to root_path
    end
  end

  def destroy
    grab_host
    @host.destroy
    redirect_to root_path
  end

  private
  def host_params
    params.require(:host).permit(:name, :email, :password)
  end

  def grab_host
    @host = Host.find(session[:host_id])
  end
end
