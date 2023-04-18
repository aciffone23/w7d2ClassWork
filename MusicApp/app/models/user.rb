class User < ApplicationRecord
    validates :email,:session_token, presence: true, uniqueness: true 
    validates :password, length: {minimum: 6}, allow_nil: true 
    validates :password_digest, presence: true 

    after_initialize :ensure_session_token
   
    attr_reader :password

    def self.find_by_credentials(email, password)
        debugger
        user = User.find_by(email: email)
        
        if user && user.is_password?(password)
            user
        else 
            nil 
        end
    end
    
    def is_password?(password)
        pass = Bcrypt::Password.new(password_digest)
        pass.is_password?(password)
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def generate_unique_session_token
        loop do
            session_token = SecureRandom::urlsafe_base64
            return session_token unless User.exists?(session_token: session_token)
        end
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end
end
