class Smoke < ActiveRecord::Base
  attr_accessible :parent_user_id, :parent_id, :user_id, :wolf_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :parent_user, :class_name => "User"
  belongs_to :wolf, :class_name => "Wolf"
  has_many :shoots, :foreign_key => "smoke_id"

  has_many :children, :class_name => "Smoke", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Smoke"   # no need to use this?

  before_save :create_url_token
  before_save :create_user_idstr_chain
 
  validates :user_id, :presence => true,
                      :uniqueness => { :scope => :wolf_id }
  validates :wolf_id, :presence => true

  default_scope :order => 'smokes.created_at DESC'

    def to_node
    #self.attributes.merge({:user_name => User.find(self.user_id).name, :children => self.children.map { |c| c.to_node }})
    self.children.empty? ? self.attributes.merge({:user_name => User.find(self.user_id).name}) :  self.attributes.merge({:user_name => User.find(self.user_id).name, :children => self.children.map { |c| c.to_node }})
    end

  #added by alex to get a list of shoots from current_user smoke to below
  def descendents_shoot
    self.wolf.shoots.all(:include => :smoke).where('user_idstr_chain LIKE ?', "#{self.user_idstr_chain}_%")
  end

  def level
    self.user_idstr_chain.length / User::IDSTR_LEN
  end

  def parent_smoke
    Smoke.where(:user_id => self.parent_user.id, :wolf_id => self.wolf.id).first
  end

  def user_chain  # this returns array of User objects in the exact sequence from root to current user
    @idstrs = self.user_idstr_chain.scan(/.{#{User::IDSTR_LEN}}/)
    @users = User.find_all_by_idstr(@idstrs)
    @indexed_users = @users.index_by(&:idstr)
    @indexed_users.values_at(*@idstrs)
  end

  def descendents_all_user_ids   # this returns an array of all user_ids below current smoke
    wolf.smokes.where('user_idstr_chain LIKE ?', "#{self.user_idstr_chain}_%").pluck(:user_id)
  end

  def descendents_by_level_user_ids(level) # this returns an array of all user_ids n level below current smoke
    wolf.smokes.where('user_idstr_chain LIKE ?', "#{self.user_idstr_chain}"+'_'*User::IDSTR_LEN*level).pluck(:user_id)
  end

  def siblings_user_ids   # this return an array of all user_ids of sibling (same smoke_parent)
    if parent_user_id == user_id
      []
    else
      @len = self.user_idstr_chain.length
      @parent_idstr_chain = self.user_idstr_chain[0..@len-1-User::IDSTR_LEN]
      @ids = wolf.smokes.where('user_idstr_chain LIKE ?', "#{@parent_idstr_chain}"+'_'*User::IDSTR_LEN).pluck(:user_id)
      @ids - [user_id]
    end
  end


  private
    def create_url_token
      self.url_token = SecureRandom.hex(16)
    end

    def create_user_idstr_chain
      if self.user_id == self.parent_user_id
        self.user_idstr_chain = self.user.idstr
      else
        self.user_idstr_chain = self.parent_smoke.user_idstr_chain + self.user.idstr
      end
    end

end
