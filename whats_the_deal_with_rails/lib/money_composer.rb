# Including the MoneyComposer module gives the class a .money method, used
# to create a composed money attribute that uses fractional storage but whole
# currency input/output.
module MoneyComposer
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    # This composer method creates a money attribute that can store cents,
    # but deal with Money instances for attribute interactions.  This allows
    # us to think in terms of dollar amounts, but store those amounts using a
    # fixed point type (integer).
    def money(column)
      composed_of column,
        :class_name => "Money",
        :mapping => ["#{column}_cents", "cents"],
        :constructor => Proc.new { |cents| Money.new(cents || 0, Money.default_currency) },
        :converter => proc { |value|
          money = (value || 0).to_money
          money.original_value = value
          money
        }
    end
  end
end
