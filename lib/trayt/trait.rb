require "trayt/validate"
require "trayt/validate_claims"

module Trayt
  module Trait
    def self.extended(base)
      base.class_eval do
        init_empty_claims
        def self.included(base)
          TracePoint.trace(:end) do |t|
            if base == t.self
              ValidateClaims.call!(base, :instance_methods, @def_claims)
              ValidateClaims.call!(base, :methods, @self_claims)
              t.disable
            end
          end
        end
      end
    end

    private

    def claim_def(claims)
      Validate.claims_structure!(claims)
      @def_claims = claims
    end

    def claim_self(claims)
      Validate.claims_structure!(claims)
      @self_claims = claims
    end

    def init_empty_claims
      @def_claims ||= {}
      @self_claims ||= {}
    end
  end
end
