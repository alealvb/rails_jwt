module JsonWebToken
  # payload = { user_id: 8 }
  def self.encode(user_data, exp = 30.minutes.from_now)
    user_data[:exp] = exp.to_i
    JWT.encode(user_data, signature_key)
  end

  def self.decode(token)
    user_data = JWT.decode(token, signature_key).first
    HashWithIndifferentAccess.new user_data
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise ExceptionHandler::ExpiredSignature, e.message
    rescue JWT::DecodeError, JWT::VerificationError => e
      raise ExceptionHandler::DecodeError, e.message
  end

  # esta llave (o firma) es usada como patron para encriptar y desencriptar el token 
  # la llave deberia ser la secret key de rails
  def self.signature_key
    'promo_9'
  end
end