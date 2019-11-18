RSpec.describe Trayt do
  it "has a version number" do
    expect(Trayt::VERSION).not_to be nil
  end

  it "exposes Trayt::Trait" do
    expect(Trayt::Trait).to be_truthy
  end

  it "doesn't expose Trayt::Validate" do
    expect {
      Trayt::Validate
    }.to raise_error(NameError, "private constant Trayt::Validate referenced")
  end
end
