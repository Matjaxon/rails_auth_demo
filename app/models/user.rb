class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :cats, foreign_key: :user_id
  has_many :cat_rental_requests

  attr_reader :password

  def self.find_by_credentials(user_name, password)
    @user = User.find_by(user_name: user_name)
    return nil unless @user
    @user.is_password?(password) ? @user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(32)
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    pw_digest = BCrypt::Password.create(password)
    self.password_digest = pw_digest
  end

  def is_password?(password)
    pw_digest = BCrypt::Password.new(self.password_digest)
    pw_digest.is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(32)
  end
end
