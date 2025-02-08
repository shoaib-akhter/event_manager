# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'dotenv'
require 'erb'

Dotenv.load


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def fetch_legislators(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = ENV['GOOGLE_CIVIC_API_KEY'] # Read the API key from .env

  civic_info.representative_info_by_address(
    address: zip,
    levels: 'country',
    roles: %w[legislatorUpperBody legislatorLowerBody]
  )
end

def format_legislator_names(legislators)
  legislator_names = legislators.officials.map(&:name)
  legislator_names.join(', ')
end

def legislators_by_zipcode(zip)
  legislators = fetch_legislators(zip)
  format_legislator_names(legislators)
rescue StandardError
  'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end
