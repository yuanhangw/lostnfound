class Authorization < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :token, :secret 

  belongs_to :user

  validates :provider, :uid, :presence => true

def self.find_or_create(auth_hash)
  unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
  	
  	password = SecureRandom.hex
    user = User.create(name: auth_hash["info"]["name"], email: auth_hash["info"]["email"], password: password, password_confirmation: password)
    
    auth = create :user => user, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
  end
  auth
end


end
