# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.column :title, :string
    t.column :created_at, :datetime
  end
end
