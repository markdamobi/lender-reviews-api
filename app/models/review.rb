class Review
  include ActiveModel::Model
  attr_accessor :title, :content, :author_name, :star_rating, :date_of_review, :author_city, :author_state
end