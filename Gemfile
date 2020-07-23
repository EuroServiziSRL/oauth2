source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '= 5.2.4.3'
# Use mysql as the database for Active Record
gem 'mysql2', '= 0.4.10' #'>= 0.4.4', '< 0.6.0'

# Use SCSS for stylesheets
gem 'sass-rails', '= 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '= 4.1.20'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '= 4.0.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# # Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '= 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '= 2.8.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '= 1.4.6', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Use Puma as the app server
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

gem 'doorkeeper', '= 5.0.3'
gem 'doorkeeper-jwt', '= 0.3.0'
gem 'grape', '= 1.2.3'
gem 'rack', '2.2.3'
gem 'rack-cors', '= 1.1.1', require: 'rack/cors'
gem 'rubyzip', '= 2.3.0'