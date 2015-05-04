class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates :title, length: { maximum: 127 }
  validates :text, presence: true, length: { maximum: 511 }
  validates_presence_of :user
  validates_presence_of :meetup
end
