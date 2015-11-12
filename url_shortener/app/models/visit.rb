# == Schema Information
#
# Table name: visits
#
#  id           :integer          not null, primary key
#  short_url_id :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Visit < ActiveRecord::Base
  belongs_to :visitor,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"

  belongs_to :visited_url,
    foreign_key: :short_url_id,
    primary_key: :id,
    class_name: "ShortenedUrl"

  def self.record_visit!(user, short_url)
    Visit.create!(short_url_id: short_url.id, user_id: user.id)
  end
end
