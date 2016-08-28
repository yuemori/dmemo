class BigqueryTable < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :data_source
end
