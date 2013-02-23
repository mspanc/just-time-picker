module Just
  module TimePicker
    module DatabaseAbstraction
      module DataTypes
        class Time
          def initialize(original_time)
            raise ArgumentError, "You must pass Time to DataTypes::Time.new" unless original_time.is_a? ::Time

            @original_time = original_time
          end

          def hour
            @original_time.hour
          end

          def min
            @original_time.min
          end

          def to_s
            "#{sprintf("%02d", hour)}:#{sprintf("%02d", min)}"
          end
        end
      end
    end
  end
end
