RSpec.describe Trayt::Trait.instance_method(:claim_self) do
  context "when argument passed is not a hash" do
    it "raises ArgumentError" do
      expect {
        module Fooable
          extend Trayt::Trait
          claim_self :foo
        end
      }.to raise_error(ArgumentError, "foo is not an instance of Hash")
    end
  end

  context "when not all argument keys are symbols" do
    it "raises ArgumentError" do
      expect {
        module Fooable
          extend Trayt::Trait
          claim_self({"foo" => 1})
        end
      }.to raise_error(ArgumentError, "foo is not an instance of Symbol")
    end
  end

  context "when not all argument values are integers" do
    it "raises ArgumentError" do
      expect {
        module Fooable
          extend Trayt::Trait
          claim_self foo: 0.12
        end
      }.to raise_error(ArgumentError, "foo => 0.12 value is not an instance of Integer")
    end
  end

  context "when claimed def arity is negative" do
    it "raises ArgumentError" do
      expect {
        module Fooable
          extend Trayt::Trait
          claim_self foo: -1
        end
      }.to raise_error(ArgumentError, "foo arity cannot be negative")
    end
  end

  context "when class doesn't implement trait" do
    context "at all" do
      it "raises NotImplementedError " do
        module Fooable
          extend Trayt::Trait
          claim_self foo: 0
        end

        expect {
          class Foo
            include Fooable
          end
        }.to raise_error(NotImplementedError, "Foo must implement foo accepting 0 arguments")
      end
    end

    context "with valid method arity" do
      it "raises NotImplementedError" do
        module Fooable
          extend Trayt::Trait
          claim_self foo: 2
        end

        expect {
          class Foo
            include Fooable
            def self.foo(bar)
            end
          end
        }.to raise_error(NotImplementedError, "Foo implements foo accepting 1 arguments instead of 2")
      end
    end
  end

  context "when trait is implemented properly" do
    it "doesn't raise error" do
      module Fooable
        extend Trayt::Trait
        claim_self foo: 2
      end

      expect {
        class Foo
          include Fooable
          def self.foo(bar, baz)
          end
        end
      }.not_to raise_error
    end
  end
end
