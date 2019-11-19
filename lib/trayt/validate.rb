module Trayt
  module Validate
    def self.claims_structure!(claims)
      Validate.is_a!(Hash, claims)
      Validate.keys_are!(Symbol, claims)
      Validate.values_are!(Integer, claims)
      Validate.arities_not_negative!(claims)
    end

    def self.is_a!(klass, object)
      return if object.is_a? klass
      raise ArgumentError, "#{object} is not an instance of #{klass.name}"
    end

    def self.keys_are!(klass, hash)
      is_a!(Hash, hash)
      hash.each_key do |key|
        next if key.is_a? klass
        raise ArgumentError, "#{key} is not an instance of #{klass}"
      end
    end

    def self.values_are!(klass, hash)
      is_a!(Hash, hash)
      hash.each_pair do |key, value|
        next if value.is_a?(klass)
        raise ArgumentError, "#{key} => #{value} value is not an instance of #{klass}"
      end
    end

    def self.arities_not_negative!(hash)
      is_a!(Hash, hash)
      hash.each_pair do |key, value|
        next if value >= 0
        raise ArgumentError, "#{key} arity cannot be negative"
      end
    end
  end
  private_constant :Validate
end
