class Property < ApplicationRecord
  has_many :units, dependent: :destroy

  validates :building_name, :street_address, :city, :state, :zip_code, presence: true

  validates :building_name, uniqueness: { scope: [:street_address, :city, :state, :zip_code], case_sensitive: false }

  before_validation :normalize_property_info
  
end
