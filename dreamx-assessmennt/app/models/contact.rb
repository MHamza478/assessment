class Contact < ActiveRecord::Base
  require 'csv'
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  class << self
    def to_csv
      attributes = %w{id first_name last_name email note}
      contacts = Contact.all

      CSV.generate(headers: true) do |csv|
        csv << attributes

        contacts.each do |car|
          csv << attributes.map{ |attr| car.send(attr) }
        end
      end
    end
  end
end
