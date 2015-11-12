# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :presence => true, :uniqueness => true

  belongs_to :submitter,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"

  has_many :visits,
    foreign_key: :short_url_id,
    primary_key: :id,
    class_name: "Visit"

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor

  def num_clicks
    visits.count
  end

  def num_uniques
    # visits.select(:user_id).distinct.where( :created_at => ((Time.now - 600)..Time.now)).count
    visitors.count
  end

  def self.random_code
    code = nil
    until ShortenedUrl.find_by(short_url: code).nil? && code != nil
      code = SecureRandom.urlsafe_base64(12)
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    if find_by(long_url: long_url).nil?
      create!(short_url: random_code, long_url: long_url, user_id: user.id)
    else
      puts "A short url already exists!"
      find_by(long_url: long_url)
    end
  end
end
