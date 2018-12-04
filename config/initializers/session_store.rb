options = {
  key: "_finance_session"
}

case Rails.env
when "development", "test"
  options.merge!(domain: "lvh.me")
when "production"
  #TBA
end

Finance::Application.config.session_store :cookie_store, options