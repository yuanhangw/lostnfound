class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :wolves, :dependent => :destroy
  has_many :smokes, :foreign_key => "user_id", :dependent => :destroy
  has_many :smoked_wolves, :through => :smokes, :source => :wolf_id

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, 
                    :format => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :length => { :minimum => 6}
  validates :password_confirmation, :presence => true

  def smoked?(wolf)
    smokes.find_by_user_id_and_wolf_id(self.id, wolf.id)
  end

  def smoke!(wolf)
    smokes.create!(:wolf_id => wolf.id)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.hex
    end

end
