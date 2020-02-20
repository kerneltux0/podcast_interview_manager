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

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= Host.find_by_id(session[:host_id])
  end

  def logged_in?
    current_user != nil
  end
end
