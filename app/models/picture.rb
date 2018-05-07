class Picture < ApplicationRecord
    belongs_to :imageable, polmorphic: true 
end
