class Domain < ApplicationRecord
  validates :url, uniqueness: true

  include AASM

  aasm do
    state :ok
    state :not_ok, initial: true

    event :pass do
      transitions from: :not_ok, to: :ok
    end

    event :fail do
      transitions from: :ok, to: :not_ok
    end
  end

end
