module Formtastic
  module Inputs
    class JustTimePickerInput 
      include ::Formtastic::Inputs::Base

      def to_html
        input_wrapping do
          hour_value   = builder.object.send("#{method}_hour").nil?   ? 0 : builder.object.send("#{method}_hour")
          minute_value = builder.object.send("#{method}_minute").nil? ? 0 : builder.object.send("#{method}_minute")

          hour_value   = sprintf("%02d", hour_value)
          minute_value = sprintf("%02d", minute_value)
          
          label_html <<
          builder.text_field("#{method}_hour", input_html_options.merge({ :class => "just-time-picker-field just-time-picker-time just-time-picker-time-hour", :value => hour_value, :maxlength => 2, :size => 2 })) <<
          ":" <<
          builder.text_field("#{method}_minute", input_html_options.merge({ :class => "just-time-picker-field just-time-picker-time just-time-picker-time-minute", :value => minute_value, :maxlength => 2, :size => 2 }))
        end
      end
    end
  end
end


