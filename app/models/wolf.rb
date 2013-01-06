class Wolf < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  has_many :smokes, :foreign_key => "wolf_id", :dependent => :destroy
  has_many :smokers, :through => :smokes, :source => :user_id
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  default_scope :order => 'wolves.created_at DESC'
end
