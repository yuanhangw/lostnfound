class Smoke < ActiveRecord::Base
  attr_accessible :parent_user_id, :parent_id, :user_id, :wolf_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :wolf, :class_name => "Wolf"


  has_many :children, :class_name => "Smoke",
    :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Smoke"

  before_save :create_url_token
 
  validates :user_id, :presence => true,
                      :uniqueness => { :scope => :wolf_id }
  validates :wolf_id, :presence => true

  default_scope :order => 'smokes.created_at DESC'

    def to_node
    #self.attributes.merge({:user_name => User.find(self.user_id).name, :children => self.children.map { |c| c.to_node }})
    self.children.empty? ? self.attributes.merge({:user_name => User.find(self.user_id).name}) :  self.attributes.merge({:user_name => User.find(self.user_id).name, :children => self.children.map { |c| c.to_node }})
    end



  private
    def create_url_token
      self.url_token = SecureRandom.hex(16)
    end



end
