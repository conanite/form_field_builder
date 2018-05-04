require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  before { I18n.locale = :fr }

  it "should create a custom field" do
    ffb = form_field_builder Person.new(name: "Squiggle Squoggle")
    expected = expectable "person-name", "Nom", "<INPUT:person[name]:Squiggle Squoggle/>"
    expect(fix_field ffb.custom(:name) { |n, v| "<INPUT:#{n}:#{v}/>" } ).to eq expected
  end

  it "should create a custom field with a custom html tag" do
    ffb = form_field_builder Person.new(name: "Squiggle Squoggle"), tag: "p"
    expected = expectable "person-name", "Nom", "<INPUT:person[name]:Squiggle Squoggle/>", nil, "p"
    expect(fix_field ffb.custom(:name) { |n, v| "<INPUT:#{n}:#{v}/>" } ).to eq expected
  end

  it "should create a field name with an array suffix" do
    wally = Person.new id: 347
    ffb = form_field_builder Group.new(group_people: [GroupPerson.new(person: wally)]), input_name_prefix: "x"
    expected = expectable "x-group_people", "Les gens", "<input type='hidden' name='x[group_people_attributes][][person_id]' value='347'/>"
    expect(fix_field ffb.custom(:group_people, array_field: true) { |n, v|
             v.map { |gp|
               gpffb = form_field_builder gp, input_name_prefix: n
               gpffb.hidden :person_id
             }.join
           } ).to eq expected
  end

  it "should create a field name for a belongs_to association" do
    jimmy = Person.new id: 345
    ffb = form_field_builder GroupPerson.new(person: jimmy)
    expected = expectable "group_person-person", "Qui", "<INPUT:group_person[person_id]:345/>"
    expect(fix_field ffb.custom(:person) { |n, v| "<INPUT:#{n}:#{v.id}/>" } ).to eq expected
  end

  it "should create a field name with no prefix" do
    jimmy = Person.new id: 346
    ffb = form_field_builder GroupPerson.new(person: jimmy), input_name_prefix: ''
    expected = expectable "-person", "Qui", "<INPUT:person_id:346/>"
    expect(fix_field ffb.custom(:person) { |n, v| "<INPUT:#{n}:#{v.id}/>" } ).to eq expected
  end
end
