require "trayt/validate"

module Trayt
  module Trait
    def self.extended(base)
      base.class_eval do
        def self.included(base)
          TracePoint.trace(:end) do |t|
            if base == t.self
              Validate.def_claims_fulfilled!(base, @def_claims)
              t.disable
            end
          end
        end
      end
    end

    private

    def claim_def(claims)
      Validate.def_claims_structure!(claims)
      @def_claims = claims
    end
  end
end
