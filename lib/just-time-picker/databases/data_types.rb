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

          def to_s
            return nil if @original_time.nil?

            "#{sprintf("%02d", hour)}:#{sprintf("%02d", min)}"
          end
        end
      end
    end
  end
end