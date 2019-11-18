RSpec.describe Trayt::Trait do
  it "raises ArgumentError unless hash is passed as a parameter" do
    expect {
      module Fooable
        extend Trayt::Trait
        claim_def :foo
      end
    }.to raise_error(ArgumentError, "foo is not an instance of Hash")
  end

  it "raises ArgumentError unless hash parameter has only symbol keys" do
    expect {
      module Fooable
        extend Trayt::Trait
        claims = {}
        claims["foo"] = 1
        claim_def claims
      end
    }.to raise_error(ArgumentError, "foo is not an instance of Symbol")
  end

  it "raises ArgumentError unless hash parameter has only Integer values" do
    expect {
      module Fooable
        extend Trayt::Trait
        claim_def foo: 0.12
      end
    }.to raise_error(ArgumentError, "foo => 0.12 value is not an instance of Integer")
  end

  it "raises ArgumentError if claimed def arity is negative" do
    expect {
      module Fooable
        extend Trayt::Trait
        claim_def foo: -1
      end
    }.to raise_error(ArgumentError, "foo arity cannot be negative")
  end

  it "raises NotImplementedError for class not implementing trait" do
    module Fooable
      extend Trayt::Trait
      claim_def foo: 0
    end

    expect {
      class Foo
        include Fooable
      end
    }.to raise_error(NotImplementedError, "Foo must implement foo accepting 0 arguments")
  end

  it "raises NotImplementedError for class implementing trait with invalid method arity" do
    module Fooable
      extend Trayt::Trait
      claim_def foo: 2
    end

    expect {
      class Foo
        include Fooable
        def foo(bar)
        end
      end
    }.to raise_error(NotImplementedError, "Foo implements foo accepting 1 arguments instead of 2")
  end
end
