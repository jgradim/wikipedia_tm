# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wikipedia_session',
  :secret      => '9277fb60dae1e1c51df18a5b872e6f90329ef4368f4e1a68249d49b2b2133ce907b3b37e16fc5f0e8c49c022aa67e6fd113b6d7b9016f301f897fd96c0dc6b9b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
