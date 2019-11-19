module Trayt
  class ValidateClaims
    def initialize(klass, type, claims)
      @klass = klass
      @type = type
      @claims = claims
    end

    def self.call!(klass, type, claims)
      new(klass, type, claims).check_claims_fulfilled!
    end

    def check_claims_fulfilled!
      @claims.each_pair do |method, arity|
        check_method_defined!(method, arity)
        check_method_arity!(method, arity)
      end
    end

    private

    def check_method_defined!(claimed_method, claimed_arity)
      message = "#{@klass} must implement #{claimed_method} accepting #{claimed_arity} arguments"
      raise NotImplementedError, message unless methods.include?(claimed_method)
    end

    def check_method_arity!(claimed_method, claimed_arity)
      arity = method(claimed_method).arity
      message = "#{@klass} implements #{claimed_method} accepting #{arity} arguments instead of #{claimed_arity}"
      raise NotImplementedError, message if arity != claimed_arity
    end

    def method(name)
      case @type
      when :instance_methods
        @klass.instance_method(name)
      when :methods
        @klass.method(name)
      end
    end

    def methods
      case @type
      when :instance_methods
        @klass.instance_methods
      when :methods
        @klass.methods
      end
    end
  end
  private_constant :ValidateClaims
end
