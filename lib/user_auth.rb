require 'openssl'

module UserAuth
  class Token
    def self.encode(payload, exp = 1.week.from_now)
      payload[:exp] = exp.utc.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def self.decode(token)
      payload = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      DecodedToken.new(payload)
    rescue
      NilToken.new
    end
  end

  class NilToken
    def expired?
      true
    end
  end

  class DecodedToken < HashWithIndifferentAccess
    def expired?
      self[:exp] <= Time.now.utc.to_i
    end
  end

  class ConfirmationToken
    def initialize(user)
      sha256 = OpenSSL::Digest::SHA256.new

      @token = OpenSSL::HMAC.hexdigest(
          sha256,
          Rails.application.secrets.secret_key_base,
          "#{user.id}-#{Time.now.utc}"
      )
    end

    def to_s
      @token
    end
  end
end
