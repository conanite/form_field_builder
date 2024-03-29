require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  before { I18n.locale = :fr }

  it "creates a date input field with a value" do
    ffb = form_field_builder Person.new(dob: "2013-02-11")
    input = "<input class='date_input' type='text' name='person[dob]' value='11-févr-2013' placeholder='jj-mmm-aaaa' id='iNpUtId'/>"
    expected = expectable "person-dob", "Né(e) le", input
    expect(fix_field ffb.date_input("dob")).to eq expected
  end

  it "creates a disabled date input field with a value" do
    ffb = form_field_builder Person.new(dob: "2013-02-11")
    input = "<input class='date_input' type='text' name='person[dob]' value='11-févr-2013' placeholder='jj-mmm-aaaa' disabled='disabled' id='iNpUtId'/>"
    expected = expectable "person-dob", "Né(e) le", input
    expect(fix_field ffb.date_input("dob", disabled: true)).to eq expected
  end
end
