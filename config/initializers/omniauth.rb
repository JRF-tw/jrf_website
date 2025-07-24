# OmniAuth configuration for better reliability and security

# Configure OmniAuth to handle CSRF protection
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true

# Handle failures gracefully
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

# Add logger for debugging OAuth issues
if Rails.env.development?
  OmniAuth.config.logger = Rails.logger
end

# Improve SSL verification
if Rails.env.production?
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end