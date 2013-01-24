class Praise < ActiveRecord::Base
  attr_accessible :user_id, :shoot_id, :content
  
  belongs_to :user, :class_name => "User"
  belongs_to :shoot, :class_name => "Shoot"
  has_one :smoke, :through => :shoot
  has_one :wolf, :through => :smoke

  validates :user_id, :presence => true
  validates :shoot_id, :presence => true
  validates :content, :presence => true

  default_scope :order => 'praises.created_at DESC'


end
