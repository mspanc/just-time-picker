require 'formtastic'

module Just
  module TimePicker
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        # Add load paths straight to I18n, so engines and application can overwrite it.
        require 'active_support/i18n'

        I18n.load_path += Dir[File.expand_path('../just-time-picker/locales/*.yml', __FILE__)]
      end
    end
  end
end


require 'just-time-picker/engine'
require 'just-time-picker/core'
require 'just-time-picker/databases/data_types' 
require 'just-time-picker/databases/common' 
require 'just-time-picker/databases/activerecord' if defined?(ActiveRecord::Base)
require 'just-time-picker/databases/mongoid'      if defined?(Mongoid::Document)
require 'just-time-picker/formtastic-input'
