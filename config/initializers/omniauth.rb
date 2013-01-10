OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.application.config.middleware.use OmniAuth::Builder do


  provider :facebook, '482359131805610', 'ff5443aedaf0f5306695d62d386060b9'
  provider :twitter, '21404584-Q4Cw9vncwaidjQTHkCxEewy6gLFt4c55GtPMadM0x', 'le78k1kOgGM7TitvYmkI7eKasWGIA489RGVWhEJrJJ4'

end
