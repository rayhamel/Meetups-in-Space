class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates_presence_of :user_id
  validates_presence_of :meetup_id
end
