class Unit < ApplicationRecord
  belongs_to :property

  validates :unit_number, presence: true, uniqueness: { scope: :property_id}

end
