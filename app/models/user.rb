class User < ActiveRecord::Base
  # get modules to help with some functionality
  include CreameryHelpers::Validations

  has_secure_password

  # Relationships
  belongs_to :employee

  # Validations
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"
  validate :employee_is_active_in_system, on: :update
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long", allow_blank: true
  
  # login by email address
  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
  
  # for use in authorizing with CanCan
  def role?(authorized_role)
    return false if self.employee.role.nil?
    self.employee.role.downcase.to_sym == authorized_role
  end

  private
  def employee_is_active_in_system
    is_active_in_system(:employee)
  end

end
