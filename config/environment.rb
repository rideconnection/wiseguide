# Load the Rails application.
require File.expand_path('../application', __FILE__)

EMAIL_FROM = "no-reply@rideconnection.org"

ALL_GENDERS = [["Female", "F"], ["Male", "M"], ["Other", "O"]]

REASONS_NOT_COMPLETED = ["Could not reach", "Duplicate request", "Out-of-service area", "Request withdrawn", "Ride Together inquiry", "Travel training inquiry", "Other"]

# Initialize the Rails application.
Rails.application.initialize!
