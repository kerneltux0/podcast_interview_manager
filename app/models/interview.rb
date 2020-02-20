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

class Interview < ApplicationRecord
  belongs_to :show
  has_one :guest
  validates :start_time, presence: true
  validates :end_time, presence: true
  # validates :date, presence: true
  accepts_nested_attributes_for :guest
  scope :was_recorded, -> { where(:recorded => true).where(published: false) }
  scope :is_published, -> { where(:published => true) }
  scope :pending, -> { where(recorded: false).where(published: false)  }
  validates_date :date, :on_or_after => lambda {Time.now.strftime("%m/%d/%Y")}
  # validates_time :start_time, :before => :end_time
  # validates_time :start_time, :on_or_after => lambda {Time.now.strftime("%I:%M %p")}
end
