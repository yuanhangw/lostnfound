OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.application.config.middleware.use OmniAuth::Builder do

  # require 'openid/store/filesystem'

  # # load certificates
  # require "openid/fetchers"
  # OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"
  
  provider :facebook, '482359131805610', 'ff5443aedaf0f5306695d62d386060b9'
  provider :twitter, 'Q2xgUe6W5kpGtFSbHNtPAg', 'QwoOTeYVG7tPCtfztRoER51AafXP5L1CXJ9oyCzi4'
  provider :google_oauth2, '235803121137', 'H_xD3J57eHEsScu1Yd53B1mz'
  
  # # dedicated openid
  # provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end
