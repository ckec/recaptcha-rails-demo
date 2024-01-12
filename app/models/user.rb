class User < ApplicationRecord
  validates :first_name, presence: { message: "cannot be empty" }
  validates :last_name, presence: { message: "cannot be empty" }
end
