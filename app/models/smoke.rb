class Smoke < ActiveRecord::Base
  attr_accessible :parent_user_id, :user_id, :wolf_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :wolf, :class_name => "Wolf"

  before_save :create_url_token
 
  validates :user_id, :presence => true,
                      :uniqueness => { :scope => :wolf_id }
  validates :wolf_id, :presence => true

  default_scope :order => 'smokes.created_at DESC'

  private
    def create_url_token
      self.url_token = SecureRandom.hex(16)
    end

end
