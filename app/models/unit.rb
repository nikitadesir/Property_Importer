class Unit < ApplicationRecord
  belongs_to :property

  validates :unit_number, presence: true, uniqueness: { scope: :property_id}

  before_validation :normalize_unit_number

end
