module Just
  module TimePicker
    class Engine < Rails::Engine
      if Rails.version >= "3.1"
        initializer "Just DateTime Picker precompile hook" do |app|
          app.config.assets.precompile += %w(just_time_picker/base.css)
        end
      end
    end
  end
end

