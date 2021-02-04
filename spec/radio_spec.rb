require "spec_helper"

RSpec::describe FormFieldBuilder::RadioFieldBehaviour do
  include FormFieldBuilderHelpers

  it "should create a yes_no_any input field with a true value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: true), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value='true'/>
<div class='option_container'>
<div class='option yes value-true selected'>yes</div>
<div class='option no  value-false ' >no</div>
<div class='option any value-nil '>all</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_no_any("happy")).to eq expected
  end

  it "should create a yes_default_no_any input field with a true value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: true), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value='true'/>
<div class='option_container'>
<div class='option yes value-true selected'>yes</div>
<div class='option no  value-nil ' >no</div>
<div class='option any value-false '>all</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_default_no_any("happy")).to eq expected
  end

  it "creates a yes_no_any input field with a false value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: false), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value='false'/>
<div class='option_container'>
<div class='option yes value-true '>yes</div>
<div class='option no  value-false selected' >no</div>
<div class='option any value-nil '>all</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_no_any("happy")).to eq expected
  end

  it "creates a yes_default_no_any input field with a false value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: false), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value='false'/>
<div class='option_container'>
<div class='option yes value-true '>yes</div>
<div class='option no  value-nil ' >no</div>
<div class='option any value-false selected'>all</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_default_no_any("happy")).to eq expected
  end

  it "should create a yes_no_any input field with a nil value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: nil), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value=''/>
<div class='option_container'>
<div class='option yes value-true '>yes</div>
<div class='option no  value-false ' >no</div>
<div class='option any value-nil selected'>all</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_no_any("happy")).to eq expected
  end

  it "should create a yes_default_no_any input field with a nil value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: nil), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value=''/>
<div class='option_container'>
<div class='option yes value-true '>yes</div>
<div class='option no  value-nil selected' >no</div>
<div class='option any value-false '>all</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_default_no_any("happy")).to eq expected
  end

  it "should create a yes_no input field with a value using the same ui as #yes_no_any" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: true), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value='true'/>
<div class='option_container'>
<div class='option yes value-true  selected'>yes</div>
<div class='option no  value-false ' >no</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_no("happy")).to eq expected
  end

  it "should create a yes_no input field with no value using the same ui as #yes_no_any" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: nil), input_name_prefix: "x"
    input = "<div class='yes_no_any'>
<input type='hidden' name='x[happy]' value=''/>
<div class='option_container'>
<div class='option yes value-true  '>yes</div>
<div class='option no  value-false ' >no</div>
</div>
</div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.yes_no("happy")).to eq expected
  end

  it "should create a yes-no radio input field with a value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(happy: true), input_name_prefix: "x"
    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='x[happy]_true_' type='radio' name='x[happy]' value='true' checked='checked'>
<label for='x[happy]_true_'>yes</label></div>
<div class='radio-option'>
<input id='x[happy]_false_' type='radio' name='x[happy]' value='false'>
<label for='x[happy]_false_'>no</label></div></div>"
    expected = expectable "x-happy", "Happy", input
    expect(fix_field ffb.boolean("happy")).to eq expected
  end

  it "should create a radio input field with a value" do
    I18n.locale = :en
    ffb = form_field_builder Person.new(sex: "f"), input_name_prefix: "element"
    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='element[sex]_m_123' type='radio' name='element[sex]' value='m'>
<label for='element[sex]_m_123'>Male</label></div>
<div class='radio-option'>
<input id='element[sex]_f_123' type='radio' name='element[sex]' value='f' checked='checked'>
<label for='element[sex]_f_123'>Female</label></div>
<div class='radio-option'>
<input id='element[sex]_o_123' type='radio' name='element[sex]' value='o'>
<label for='element[sex]_o_123'>Other</label></div></div>"
    expected = expectable "element-sex", "sex", input
    expect(fix_field ffb.radio("sex", [["m","Male"],["f","Female"],["o","Other"]], id: 123)).to eq expected
  end

  it "should create a radio input field from a set of objects" do
    W = Struct.new :id, :shape
    objects = [W.new(1, "square"), W.new(2, "round"), W.new(42, "hexagonal")]

    Thing = Struct.new :widget_id

    I18n.locale = :en
    ffb = FormFieldBuilder::Plain.new Thing.new(42)

    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='thing[widget_id]_1_' type='radio' name='thing[widget_id]' value='1'>
<label for='thing[widget_id]_1_'>square</label></div>
<div class='radio-option'>
<input id='thing[widget_id]_2_' type='radio' name='thing[widget_id]' value='2'>
<label for='thing[widget_id]_2_'>round</label></div>
<div class='radio-option'>
<input id='thing[widget_id]_42_' type='radio' name='thing[widget_id]' value='42' checked='checked'>
<label for='thing[widget_id]_42_'>hexagonal</label></div></div>"
    expect(fix_field ffb.object_radio(:widget_id, objects, :shape)).to eq input
  end

  it "should create a radio input field with an 'all' option" do
    I18n.locale = :fr
    ffb = form_field_builder Person.new(sex: "f"), input_name_prefix: "element"
    input = "<div class='radio_container'>
<div class='radio-option'>
<input id='element[sex]__123' type='radio' name='element[sex]' value=''>
<label for='element[sex]__123'>tous</label></div>
<div class='radio-option'>
<input id='element[sex]_m_123' type='radio' name='element[sex]' value='m'>
<label for='element[sex]_m_123'>Mâle</label></div>
<div class='radio-option'>
<input id='element[sex]_f_123' type='radio' name='element[sex]' value='f' checked='checked'>
<label for='element[sex]_f_123'>Femelle</label></div>
<div class='radio-option'>
<input id='element[sex]_o_123' type='radio' name='element[sex]' value='o'>
<label for='element[sex]_o_123'>Autre</label></div></div>"
    expected = expectable "element-sex", "sexe", input
    expect(fix_field ffb.all_radio("sex", [["m","Mâle"],["f","Femelle"],["o","Autre"]], id: 123)).to eq expected
  end

  it "creates a radio input field with choices, label, description, and post-description" do
    I18n.locale = :fr
    ffb = form_field_builder Group.new
    input = "<p class='description'>Merci de nous donner votre accord</p>
<div class='radio_container'>
<div class='radio-option'>
<input id='group[purpose]_y_' type='radio' name='group[purpose]' value='y'>
<label for='group[purpose]_y_'>nous autorisons</label></div>
<div class='radio-option'>
<input id='group[purpose]_n_' type='radio' name='group[purpose]' value='n'>
<label for='group[purpose]_n_'>nous n&#39;autorisons pas</label></div></div>
<p class='description'>l'utilisation de notre photo</p>"
    expected = expectable "group-purpose", "Destination", input
    opts = [["y", "nous autorisons"],["n", "nous n'autorisons pas"]]
    desc = { fr: "Merci de nous donner votre accord", en: "Please agree with us"}
    post = { fr: "l'utilisation de notre photo", en: "the use of our photo"}
    r = ffb.radio("purpose", opts, desc: desc, post_desc: post)
    expect(fix_field r).to eq expected
  end
end
