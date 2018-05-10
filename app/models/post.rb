class Post < ApplicationRecord
    has_many :pictures, as: :imageable
end
