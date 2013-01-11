class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :wolves, :dependent => :destroy
  has_many :smokes, :foreign_key => "user_id", :dependent => :destroy
  has_many :smoked_wolves, :through => :smokes, :source => :wolf
  has_many :authorizations, :dependent => :destroy

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

  def wolf_feed
  
    self.smoked_wolves
    
  end

  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end


  def add_authorization(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash[:provider], auth_hash[:uid])
      Authorization.create :user_id => self.id, :provider => auth_hash[:provider], :uid => auth_hash[:uid],:token => auth_hash[:token], :secret => auth_hash[:secret]
    end
  end


  private

    def create_remember_token
      self.remember_token = SecureRandom.hex
    end



end
