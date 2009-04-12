# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_diffmon_session',
  :secret      => '01762c60a81dd9928058bf935505780ffc08db7480ae836a67e94bba24acf22f3313c09a7c47e0e5a7db713ecf3e21f6b9c1a78eff098e95d37aa3c43b8c9ed7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
