# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, :spire, presence: true

  def dispatcher?
    !admin?
  end
end
