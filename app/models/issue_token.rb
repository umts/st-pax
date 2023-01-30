class IssueToken < ApplicationRecord
  validates :singleton, inclusion: { in: [0] }

  class << self
    delegate :token, to: :instance

    def instance
      create_with(singleton: 0).first_or_create
    end
  end
end
