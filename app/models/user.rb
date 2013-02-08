class User < ActiveRecord::Base
  IDSTR_LEN = 7

  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :wolves, :dependent => :destroy
  has_many :smokes, :foreign_key => "user_id", :dependent => :destroy
  has_many :smoked_wolves, :through => :smokes, :source => :wolf
  has_many :shoots, :foreign_key => "user_id", :dependent => :destroy
  has_many :shot_wolves, :through => :shoots, :source => :wolf
  has_many :praises, :foreign_key => "user_id", :dependent => :destroy
  has_many :praised_shoots, :through => :praises, :source => :shoot
  has_many :authorizations, :dependent => :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_save :create_idstr

  validates :name, :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, 
                    :format => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :length => { :minimum => 6}
  validates :password_confirmation, :presence => true
  validates :idstr, :uniqueness => true

  def smoked?(wolf)
    smokes.find_by_user_id_and_wolf_id(self.id, wolf.id)
  end

  def smoke!(wolf)
    smokes.create!(:wolf_id => wolf.id)
  end

  def descendent_shoots(wolf)

    @smoke = smokes.find_by_wolf_id(wolf.id)
    if @smoke.nil? 
      nil
    else 
      wolf.shoots.where('user_idstr_chain LIKE ?', "#{@smoke.user_idstr_chain}%")
    end

  end

 #there seems to be problem with this two functions

  def smoke_shot?(smoke)
    shoots.find_by_user_id_and_smoke_id(self.id, smoke.id)
  end

  def wolf_shot?(wolf)
    wolf.shoots.find_by_user_id(self.id)
  end

  def praised?(shoot)
    praises.find_by_shoot_id(shoot.id)
  end

  def wolf_feed
  
    (self.shot_wolves | self.smoked_wolves)
    
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

    def create_idstr
      begin
        token = rand(36**IDSTR_LEN).to_s(36)
        token = '0'*(IDSTR_LEN-token.length) + token;
      end while User.find_by_idstr(token)!=nil
      self.idstr = token
    end


end
