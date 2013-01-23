class Shoot < ActiveRecord::Base
  attr_accessible :user_id, :smoke_id, :content
  
  belongs_to :user, :class_name => "User"
  belongs_to :smoke, :class_name => "Smoke"
  has_one :wolf, :through => :smokes
  has_many :praises, :foreign_key => "shoot_id"
  has_many :praisers, :through => :praises, :source => :user

  validates :user_id, :presence => true
  validates :smoke_id, :presence => true
  validates :content, :presence => true

  default_scope :order => 'shoots.created_at DESC'


end
