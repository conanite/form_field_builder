require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  describe "some examples in french" do
    before { I18n.locale = :fr }

    it "should create a password field" do
      ffb = form_field_builder Person.new
      input = "<input type='password' name='person[secret]'/>"
      expected = expectable "person-secret", "Secret", input
      expect(fix_field ffb.password(:secret)).to eq expected
    end

    it "should create a password field with an id attribute on the input element" do
      ffb = form_field_builder Person.new
      input = "<input type='password' name='person[secret]' id='foobar'/>"
      expected = expectable "person-secret", "Secret", input
      expect(fix_field ffb.password(:secret, input_attributes: { id: "foobar" })).to eq expected
    end
  end
end
