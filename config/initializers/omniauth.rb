OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.application.config.middleware.use OmniAuth::Builder do


  provider :facebook, '482359131805610', 'ff5443aedaf0f5306695d62d386060b9'
  provider :twitter, 'Q2xgUe6W5kpGtFSbHNtPAg', 'QwoOTeYVG7tPCtfztRoER51AafXP5L1CXJ9oyCzi4'

end
