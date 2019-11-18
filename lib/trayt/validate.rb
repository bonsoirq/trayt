module Trayt
  module Validate
    def self.def_claims_structure!(claims)
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

    def self.def_claims_fulfilled!(klass, claims)
      claims.each_pair do |method, arity|
        Validate.instance_method_defined!(klass, method, arity)
        Validate.instance_method_arity!(klass, method, arity)
      end
    end

    def self.instance_method_defined!(klass, claimed_method, claimed_arity)
      message = "#{klass} must implement #{claimed_method} accepting #{claimed_arity} arguments"
      raise NotImplementedError, message unless klass.instance_methods.include?(claimed_method)
    end

    def self.instance_method_arity!(klass, claimed_method, claimed_arity)
      method_arity = klass.instance_method(claimed_method).arity
      message = "#{klass} implements #{claimed_method} accepting #{method_arity} arguments instead of #{claimed_arity}"
      raise NotImplementedError, message if method_arity != claimed_arity
    end
  end
  private_constant :Validate
end
