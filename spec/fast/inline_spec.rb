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

    context "multiple refences" do
      subject { described_class.local_variable("a = 1;b = 2;a + b") }
      it "inline multiple local variable references with the current expression" do
        is_expected.to eq(";;1 + 2")
      end
    end
  end

  describe ".method_def" do
    context "without arguments" do
      subject { described_class.method_def("def one; 1 end; one") }
      it "inline method definition with the current method call" do
        is_expected.to eq("; 1")
      end
    end
=begin
    context "arguments in method" do
      subject { described_class.method_def("def plus_one number; number + 1 end; plus_one(1)") }
      it "inline multiple local variable references with the current expression" do
        is_expected.to eq(";;1 + 1")
      end
    end
=end
  end
end
