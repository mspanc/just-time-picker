module Just
  module TimePicker
    module DatabaseAbstraction
      module Common
        extend ActiveSupport::Concern
        
        included do
          # Defines attribute specified as +field_name+ as field that will
          # be underlying storage for Just Time Picker.
          #
          # You can pass options by passing a Hash to the +options+ parameter.
          # Currently the only supported option is +:add_to_attr_accessible+
          # which if set to +true+ automatically calls +attr_accessible+ for
          # attribute passed as +field_name+ and all virtual attributes created
          # by Just Date/Time Picker.
          #
          # * *Arguments*    :
          #   - +field_name+ -> attribute to turn into +Just Date/Time Picker+ storage
          #   - +options+ -> +Hash+ with options
          #     - +:add_to_attr_accessible+ -> call automatically attr_accessible for attributes? (+boolean+)
          # 
          def self.just_define_time_picker(field_name, options = {})
            validates "#{field_name}_hour",   :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 23, :message => :just_time_invalid_hour }, :allow_nil => true, :allow_blank => false
            validates "#{field_name}_minute", :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 59, :message => :just_time_invalid_minute }, :allow_nil => true, :allow_blank => false

            after_validation do 
              hour_attribute   = "#{field_name}_hour".to_sym
              minute_attribute = "#{field_name}_minute".to_sym
              hour_value       = self.send(hour_attribute)
              minute_value     = self.send(minute_attribute)

              self.errors[hour_attribute].each{ |e| self.errors[field_name] << e }
              self.errors[minute_attribute].each{ |e| self.errors[field_name] << e }
              
              self.errors[field_name].uniq!
            end


            define_method field_name do 
              DataTypes::Time.new read_attribute(field_name)
            end

            define_method "#{field_name}=" do |v|
              if v.is_a? DataTypes::Time
                send "#{field_name}_hour=",   v.hour
                send "#{field_name}_minute=", v.min
                
              elsif v.is_a? String
                raise AttributeError, "If you pass a string to #{field_name}=, the only accepted format is HH:MM:SS" unless v =~ /^([0-2][0-9]):([0-5][0-9]):([0-5][0-9])$/
                send "#{field_name}_hour=",   $1
                send "#{field_name}_minute=", $2

              else
                super v
              end
            end


            define_method "#{field_name}_hour" do 
              if instance_variable_get("@#{field_name}_hour")
                instance_variable_get("@#{field_name}_hour")
              
              elsif send(field_name)
                send(field_name).hour

              else
                nil
              end
            end

            define_method "#{field_name}_hour=" do |v|
              if v.to_s.empty?
                instance_variable_set("@#{field_name}_hour", nil)
              else
                instance_variable_set("@#{field_name}_hour", v.to_i)
              end
              
              just_combine_time field_name
            end


            define_method "#{field_name}_minute" do 
              if instance_variable_get("@#{field_name}_minute")
                instance_variable_get("@#{field_name}_minute")
              
              elsif send(field_name)
                send(field_name).min

              else
                nil
              end
            end
            
            define_method "#{field_name}_minute=" do |v|
              if v.to_s.empty?
                instance_variable_set("@#{field_name}_minute", nil)
              else
                instance_variable_set("@#{field_name}_minute", v.to_i)
              end
              
              just_combine_time field_name
            end
            
            if options.has_key? :add_to_attr_accessible and options[:add_to_attr_accessible] == true
              attr_accessible "#{field_name}_date".to_sym, "#{field_name}_hour".to_sym, "#{field_name}_minute".to_sym
            end
          end # just_define_time_picker

          protected

          # Combines values passed to individual fields (hour and minutes) into syntax acceptable by DB.
          #
          # It performs validation by trying to parse combined time. In case of error it just logs warning.
          # In such case, stored date/time remains unchanged.
          #
          # It performs and tries to store the value only if all components (date, hour and minutes) are set.
          # Otherwise it checks the opposite - if maybe all values are nil, and then sets NULL in the DB if
          # this condition is true.
          #
          # * *Arguments*    :
          #   - +field_name+ -> attribute that is used to represent +Just Date/Time Picker+ storage
          def just_combine_time(field_name)
            if not instance_variable_get("@#{field_name}_hour").nil? and not instance_variable_get("@#{field_name}_minute").nil?

              combined = "#{sprintf("%02d", instance_variable_get("@#{field_name}_hour"))}:#{sprintf("%02d", instance_variable_get("@#{field_name}_minute"))}:00"
              begin
                Time.zone.parse(combined)

                write_attribute field_name, combined

              rescue ArgumentError
                logger.warn "Just error while trying to set #{field_name} attribute: \"#{combined}\" is not valid time"
              end
            
            elsif instance_variable_get("@#{field_name}_hour").nil? and instance_variable_get("@#{field_name}_minute").nil?
              self.send("#{field_name}=", nil)
            end
          end
        end # included

        
      end
    end
  end
end


