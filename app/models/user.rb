# email:string
# password_digest:string
#
#password:string virtual
#password-comfirmation:string virtual
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "must be a valid email address"}
  validates :password, length: { in: 6..20 }
  validates :email, uniqueness: true

  def self.assign_from_row(row)
    user = User.where(email: row[:email]).first_or_initialize
    user.assign_attributes row.to_hash.slice(:first_name, :last_name, :password, :password_confirmation)
    user
  end
end

