require_relative "./reviews_page_parser"
require 'byebug'
class ReviewsParser

  # each page is a html_string
  def initialize(pages:)
    @pages = pages
  end

  attr_reader :reviews

  def call
    extract_reviews
  end

  def extract_reviews
    @reviews = pages.map do |page| 
      ReviewsPageParser.new(page: page).call
    end.flatten
  end

  private 
  attr_reader :pages
end