class User < ApplicationRecord

	# Password
	has_secure_password
  attr_accessor :reset_token

	# Email
	before_save :downcase_email

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	
  validates :email, presence: 	true, 
  									length:     { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  class << self

    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine::cost

      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token

    update_columns(reset_digest:  User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if the given token matches the digest.
  def authenticated?(reset_token)
    BCrypt::Password.new(reset_digest).is_password?(reset_token)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def reset_password(password)
    self.reset_digest = nil
    self.password = password
    save!
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end
end