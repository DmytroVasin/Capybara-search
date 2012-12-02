class Post < ActiveRecord::Base
    attr_accessible :query, :search_type, :search_question, :fined_query
    SEARCH_TYPES = [ 'http://www.google.com/', 'http://www.yahoo.com/' ]

    validates :search_type, inclusion: SEARCH_TYPES
    validates :search_question, :query, presence: true
end
