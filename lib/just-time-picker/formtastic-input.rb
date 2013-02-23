module Formtastic
  module Inputs
    class JustTimePickerInput 
      include ::Formtastic::Inputs::Base

      def to_html
        input_wrapping do
          combined_value = builder.object.send(method)
          
          hour_value_raw = builder.object.send("#{method}_hour")
          if not hour_value_raw.nil?
            hour_value = hour_value_raw
          elsif not combined_value.nil?
            hour_value = combined_value.hour
          else
            hour_value = "00"
          end

          minute_value_raw = builder.object.send("#{method}_minute")
          if not minute_value_raw.nil?
            minute_value = minute_value_raw
          elsif not combined_value.nil?
            minute_value = combined_value.min
          else
            minute_value = "00"
          end

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


