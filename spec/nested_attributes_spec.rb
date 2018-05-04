require "spec_helper"

RSpec.describe FormFieldBuilder::Plain do
  include FormFieldBuilderHelpers

  it "should generate a field with a specially crafted name for active_record nested attributes" do
    ffb = FormFieldBuilder::Plain.new Group.new(group_people: [])
    field = ffb.custom(:group_people) do |f, v|
      "field:#{f}:#{v.to_a}"
    end
    expect(field).to eq "field:group[group_people_attributes][]:[]"
  end
end
