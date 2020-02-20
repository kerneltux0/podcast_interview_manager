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

class SessionsController < ApplicationController

  def new
    render 'hosts/login'
  end

  def create
    if request.env['omniauth.auth']
      oauth_process
    else
      email_pw_process
    end
  end

  def destroy
    session.delete :host_id
    redirect_to root_path
  end

  private
  def oauth_process
    oauth_email = request.env['omniauth.auth']['info']['email']
    oauth_name = request.env['omniauth.auth']['info']['name']
    oauth_pw = SecureRandom.hex
    if @host = Host.find_by(email: oauth_email)
      session[:host_id] = @host.id
      redirect_to host_path(@host)
    else
      @host = Host.new(email: oauth_email, name: oauth_name, password: oauth_pw)
      if @host.save
        session[:host_id] = @host.id
        redirect_to host_path(@host)
      end
    end
  end

  def email_pw_process
    @host = Host.find_by(email: params[:host][:email])
    if @host && @host.authenticate(params[:host][:password])
      session[:host_id] = @host.id
      redirect_to host_path(@host)
    else
      flash[:title]='¡Error!'
      flash[:notice]='Please enter valid email/password'
      render 'hosts/login'
    end
  end
  
end