require "spec_helper"

RSpec.describe FormFieldBuilder::RadioFieldBehaviour do
  include FormFieldBuilderHelpers

  it "should create a radio input field with choices from i18n" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(type: "green")
    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='person[type]_blue_123' type='radio' name='person[type]' value='blue'>
<label for='person[type]_blue_123'>Bluish</label></div>
<div class='radio-option'>
<input id='person[type]_red_123' type='radio' name='person[type]' value='red'>
<label for='person[type]_red_123'>Reddish</label></div>
<div class='radio-option'>
<input id='person[type]_green_123' type='radio' name='person[type]' value='green' checked='checked'>
<label for='person[type]_green_123'>Greenish</label></div></div>"
    expected = expectable "person-type", "Kind", input
    expect(fix_field ffb.i18n_radio("type", key: "glossary.person.type.options", id: 123)).to eq expected
  end

  it "should create a radio input field with choices, including label and description, from i18n" do
    I18n.locale = :en
    ffb = form_field_builder Group.new
    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='group[purpose]_yapping_' type='radio' name='group[purpose]' value='yapping'>
<label for='group[purpose]_yapping_'>Yapping</label>
<span class='description'> - For extensive yap</span></div>
<div class='radio-option'>
<input id='group[purpose]_fighting_' type='radio' name='group[purpose]' value='fighting'>
<label for='group[purpose]_fighting_'>Fighting</label>
<span class='description'> - or bickering or squabbling</span></div></div>"
    expected = expectable "group-purpose", "Whatfor?", input
    expect(fix_field ffb.i18n_radio("purpose", key: "glossary.group.purpose.options")).to eq expected
  end

  it "should create a select input field with choices from i18n and an 'all' option" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(type: "green")
    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='person[type]__123' type='radio' name='person[type]' value=''>
<label for='person[type]__123'>all</label></div>
<div class='radio-option'>
<input id='person[type]_blue_123' type='radio' name='person[type]' value='blue'>
<label for='person[type]_blue_123'>Bluish</label></div>
<div class='radio-option'>
<input id='person[type]_red_123' type='radio' name='person[type]' value='red'>
<label for='person[type]_red_123'>Reddish</label></div>
<div class='radio-option'>
<input id='person[type]_green_123' type='radio' name='person[type]' value='green' checked='checked'>
<label for='person[type]_green_123'>Greenish</label></div></div>"
    expected = expectable "person-type", "Kind", input
    expect(fix_field ffb.all_i18n_radio("type", key: "glossary.person.type.options", id: 123)).to eq expected
  end
end
