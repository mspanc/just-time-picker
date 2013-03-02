module Just
  module TimePicker
    module DatabaseAbstraction
      module DataTypes
        class Time
          
          def initialize(original_time)
            if original_time.nil?
              @original_time = nil
            
            else
              raise ArgumentError, "You must pass Time to DataTypes::Time.new, got #{original_time.class}" unless original_time.is_a? ::Time
              @original_time = original_time
            end
          end

          def hour
            return nil if @original_time.nil?
            
            @original_time.hour
          end

          def min
            return nil if @original_time.nil?

            @original_time.min
          end

          def to_s(include_seconds = false)
            return nil if @original_time.nil?

            if include_seconds
              "#{sprintf("%02d", hour)}:#{sprintf("%02d", min)}:00"
            else
              "#{sprintf("%02d", hour)}:#{sprintf("%02d", min)}"
            end
          end

          def xmlschema(fraction_digits = 0)
            if fraction_digits == 0
              to_s true
            else
              "#{to_s(true)}.#{"0" * fraction_digits}"
            end
          end

          alias :iso8601 :xmlschema

          def as_json 
            return nil if @original_time.nil?

            to_s true
          end


        end
      end
    end
  end
end
