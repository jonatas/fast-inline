RSpec.describe Fast::Inline do
  it "has a version number" do
    expect(Fast::Inline::VERSION).not_to be nil
  end

  describe ".local_variable" do
    context "simple expression" do
      subject { described_class.local_variable("a = 1;a + 1") }
      it "inline local variable with the current expression" do
        is_expected.to eq(";1 + 1")
      end
    end
    context "complex expression" do
      subject { described_class.local_variable("a = 1;a + a") }
      it "inline local variable references with the current expression" do
        is_expected.to eq(";1 + 1")
      end
    end
  end
end
