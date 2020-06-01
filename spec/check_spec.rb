require "spec_helper"

RSpec.describe FormFieldBuilder::Plain do
  before { I18n.locale = :fr }

  it "should create a checked checkbox" do
    ffb = FormFieldBuilder::Plain.new Person.new(name: "foo")
    actual = ffb.check :name, check_value: "foo"
    expect(actual).to eq "<input type='checkbox' name='person[name]' value='foo' checked='checked'/>"
  end

  it "should create a disabled checked checkbox" do
    ffb = FormFieldBuilder::Plain.new Person.new(name: "foo")
    actual = ffb.check :name, check_value: "foo", disabled: true
    expect(actual).to eq "<input type='checkbox' name='person[name]' value='foo' checked='checked' disabled='disabled'/>"
  end

  it "should create an unchecked checkbox" do
    ffb = FormFieldBuilder::Plain.new Person.new(name: "foo")
    actual = ffb.check :name, check_value: "bar"
    expect(actual).to eq "<input type='checkbox' name='person[name]' value='bar'/>"
  end

  it "should create a disabled unchecked checkbox" do
    ffb = FormFieldBuilder::Plain.new Person.new(name: "foo")
    actual = ffb.check :name, check_value: "bar", disabled: true
    expect(actual).to eq "<input type='checkbox' name='person[name]' value='bar' disabled='disabled'/>"
  end
end
