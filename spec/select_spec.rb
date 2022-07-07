require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  it "should create a select input field with a value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(city: "p"), input_name_prefix: "c"
    input = "<select name='c[city]'>
<option value='d'>Dublin</option>
<option value='p' selected='selected'>Paris</option>
<option value='m'>Madrid</option></select>"
    expected = expectable "c-city", "City", input
    expect(fix_field ffb.select("city", [["d","Dublin"],["p","Paris"],["m","Madrid"]])).to eq expected
  end

  it "should create a select input field with a 'please select' option" do
    I18n.locale = :fr
    ffb = form_field_builder Person.new(unit: "b"), input_name_prefix: "element"
    ffb = form_field_builder Person.new(city: "p"), input_name_prefix: "c"
    input = "<select name='c[city]'>
<option value=''>Choisir...</option>
<option value='d'>Dublin</option>
<option value='p' selected='selected'>Paris</option>
<option value='m'>Madrid</option></select>"
    expected = expectable "c-city", "Ville", input
    expect(fix_field ffb.please_select("city", [["d","Dublin"],["p","Paris"],["m","Madrid"]])).to eq expected
  end

  it "should create a select input field with choices from i18n" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(type: "green")
    input = "<select name='person[type]'>
<option value='blue'>Bluish</option>
<option value='red'>Reddish</option>
<option value='green' selected='selected'>Greenish</option>
<option value='other'>Don&#39;t use this</option></select>"
    expected = expectable "person-type", "Kind", input
    expect(fix_field ffb.i18n_select("type", "glossary.person.type.options")).to eq expected
  end

  it "should create a list of check inputs with choices from i18n" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(type: "green")
    input = "<div class='check-all-scope person-type- '>
<div class='radio_container'>
<input id='persontype-1' type='checkbox' name='person[type][]' value='blue'/>
<label for='persontype-1'>Bluish</label></div>
<div class='radio_container'>
<input id='persontype-2' type='checkbox' name='person[type][]' value='red'/>
<label for='persontype-2'>Reddish</label></div>
<div class='radio_container'>
<input id='persontype-3' type='checkbox' name='person[type][]' value='green' checked='checked'/>
<label for='persontype-3'>Greenish</label></div>
<div class='radio_container'>
<input id='persontype-4' type='checkbox' name='person[type][]' value='other'/>
<label for='persontype-4'>Don't use this</label></div></div>"
    expected = expectable "person-type", "Kind", input
    expect(fix_field ffb.multi_check_i18n("type", "glossary.person.type.options")).to eq expected
  end

  it "should create a list of check inputs with choices from i18n and custom check all/none links" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(type: "green")
    input = "<div class='check-all-scope person-type- '>
<span>check :all: :none:</span>
<div class='radio_container'>
<input id='persontype-1' type='checkbox' name='person[type][]' value='blue'/>
<label for='persontype-1'>Bluish</label></div>
<div class='radio_container'>
<input id='persontype-2' type='checkbox' name='person[type][]' value='red'/>
<label for='persontype-2'>Reddish</label></div>
<div class='radio_container'>
<input id='persontype-3' type='checkbox' name='person[type][]' value='green' checked='checked'/>
<label for='persontype-3'>Greenish</label></div>
<div class='radio_container'>
<input id='persontype-4' type='checkbox' name='person[type][]' value='other'/>
<label for='persontype-4'>Don't use this</label></div></div>"
    expected = expectable "person-type", "Kind", input
    allnone = "<span>check :all: :none:</span>"
    expect(fix_field ffb.multi_check_i18n("type", "glossary.person.type.options", check_all: allnone)).to eq expected
  end

  it "should create a select input field with choices from i18n and a 'please select' option" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(type: "green")
    input = "<select name='person[type]'>
<option value=''>Please select...</option>
<option value='blue'>Bluish</option>
<option value='red'>Reddish</option>
<option value='green' selected='selected'>Greenish</option>
<option value='other'>Don&#39;t use this</option></select>"
    expected = expectable "person-type", "Kind", input
    expect(fix_field ffb.please_i18n_select("type", "glossary.person.type.options")).to eq expected
  end

  it "should create a select input field with choices from objects and no 'please select' option" do
    o1 = Person.new id: 516, name: "JOYCE"
    o2 = Person.new id: 517, name: "YEATS"
    o3 = Person.new id: 518, name: "SHAW"
    I18n.locale = :en
    ffb = form_field_builder GroupPerson.new(person: o3)
    input = "<select name='group_person[person_id]'>
<option value='516'>JOYCE</option>
<option value='517'>YEATS</option>
<option value='518' selected='selected'>SHAW</option></select>"
    expected = expectable "group_person-person_id", "Who", input
    expect(fix_field ffb.select_objects("person_id", [o1, o2, o3], :name)).to eq expected
  end

  it "should create a select input field with choices from objects and a 'please select' option" do
    o1 = Person.new id: 516, name: "JOYCE"
    o2 = Person.new id: 517, name: "YEATS"
    o3 = Person.new id: 518, name: "SHAW"
    I18n.locale = :en
    ffb = form_field_builder GroupPerson.new(person: o3)
    input = "<select name='group_person[person_id]'>
<option value=''>Please select...</option>
<option value='516'>JOYCE</option>
<option value='517'>YEATS</option>
<option value='518' selected='selected'>SHAW</option></select>"
    expected = expectable "group_person-person_id", "Who", input
    expect(fix_field ffb.please_select_objects("person_id", [o1, o2, o3], :name)).to eq expected
  end

  it "should create a select input field with no value, chomping '_id' off name for i18n" do
    I18n.locale = :fr
    ffb = form_field_builder GroupPerson.new
    input = "<select name='group_person[person_id]'>
<option value='1'>first</option>
<option value='2'>second</option>
<option value='3'>third</option></select>"
    expected = expectable "group_person-person_id", "Qui", input

    people = [[1,"first"],[2,"second"],[3,"third"]]
    expect(fix_field ffb.select("person_id", people)).to eq expected
  end

  it "should create a select input field using #to_param to determine field value, appending _id to field name" do
    I18n.locale = :fr
    person = Person.new(id: 110, name: "The Very Best")
    ffb = form_field_builder GroupPerson.new(person: person)
    input = "<select name='group_person[person_id]'>
<option value='1'>first</option>
<option value='110' selected='selected'>The Very Best</option>
<option value='2'>second</option>
<option value='3'>third</option></select>"
    expected = expectable "group_person-person", "Qui", input

    people = [[1,"first"],[110, "The Very Best"],[2,"second"],[3,"third"]]
    expect(fix_field ffb.select("person", people)).to eq expected
  end
end
