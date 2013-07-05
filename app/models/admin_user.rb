class AdminUser < ActiveRecord::Base
  devise :two_factor_authenticatable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone_number
  
  validates :phone_number, :presence => true
  
  before_save :process_phone_number


  def send_two_factor_authentication_code(code)
    logger.info ">>>>>>>>>>>  #{code} <<<<<<<<<<<<"
  end

  private

  def process_phone_number
    self.phone_number.gsub!(/[^0-9]/, '') unless self.phone_number.blank?
  end

end
