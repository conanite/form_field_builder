require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  it "does not decorate #hidden inputs" do
    ffb = FormFieldBuilder::Plain.new Person.new(name: "foo")
    expected = "<input type='hidden' name='person[name]' value='foo'/>"
    expect(ffb.hidden(:name)).to eq expected
    expect(ffb.hidden(:name)).to be_html_safe
  end

  it "calls #to_param on AR objects and appends _id to param name" do
    person = Person.new id: 112233
    ffb = form_field_builder GroupPerson.new(person: person)
    expected = "<input type='hidden' name='group_person[person_id]' value='112233'/>"
    expect(ffb.hidden(:person)).to eq expected
  end

  it "does not try to cache stuff" do
    fa = Person.new name: "sapphire"
    ffb = form_field_builder fa, input_name_prefix: 'x'

    expect(ffb.hidden(:name)).to eq "<input type='hidden' name='x[name]' value='sapphire'/>"

    fa.name = 'tiber'
    expect(ffb.hidden(:name)).to eq "<input type='hidden' name='x[name]' value='tiber'/>"

    fa.name = 'jacob-ian'
    expect(ffb.hidden(:name)).to eq "<input type='hidden' name='x[name]' value='jacob-ian'/>"
  end

  it "is totally fine with a nil #target" do
    ffb = form_field_builder nil, input_name_prefix: 'x'
    expected = "<input type='hidden' name='x[email]' value=''/>"
    expect(ffb.hidden(:email)).to eq expected
  end
end
