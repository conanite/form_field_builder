require "spec_helper"

RSpec::describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  describe "some examples in french" do
    before { I18n.locale = :fr }

    it "should create a required text input field with no value" do
      ffb = form_field_builder Person.new
      expected = "<li class='input_row person-name'>
<label class='input-label'>
<span class='label-txt'>Nom</span>
<span class='required'>*</span></label>
<div class='error_container'></div>
<input type='text' name='person[name]' value=''/></li>"

      expect(fix_field ffb.text_input(:name, required: true)).to eq expected
    end

    it "should create a text input field with no label when configured" do
      ffb = form_field_builder Person.new, no_label: true
      expected = "<li class='input_row person-name'>
<div class='error_container'></div>
<input type='text' name='person[name]' value=''/></li>"

      expect(fix_field ffb.text_input(:name)).to eq expected
    end

    it "should create a text input field with no label when requested" do
      ffb = form_field_builder Person.new
      expected = "<li class='input_row person-name'>
<div class='error_container'></div>
<input type='text' name='person[name]' value=''/></li>"

      expect(fix_field ffb.text_input(:name, no_label: true)).to eq expected
    end

    it "uses an alternative subkey to translate label" do
      ffb = form_field_builder Person.new
      expected = "<li class='input_row person-name'>
<label class='input-label'>
<span class='label-txt'>Vous devriez vraiment mettre quelque chose ici</span></label>
<div class='error_container'></div>
<input type='text' name='person[name]' value=''/></li>"

      expect(fix_field ffb.text_input(:name, label_subkey: "required")).to eq expected
    end

    it "should create a text input field with a value" do
      ffb = form_field_builder Person.new(name: "Pops")
      input = "<input type='text' name='person[name]' value='Pops'/>"
      expected = expectable "person-name", "Nom", input
      expect(fix_field ffb.text_input("name")).to eq expected
      expect(fix_field ffb.text_input(:name) ).to eq expected
    end

    describe "filtering" do
      it "should create a text input field with a value and explicit #if option" do
        ffb = form_field_builder Person.new(name: "Pops")
        input = "<input type='text' name='person[name]' value='Pops'/>"
        expected = expectable "person-name", "Nom", input
        expect(fix_field ffb.text_input("name", if: true)).to eq expected
        expect(fix_field ffb.text_input("name", if: "any non-nil value")).to eq expected
        expect(fix_field ffb.text_input(:name,  if: true)).to eq expected
        expect(fix_field ffb.text_input(:name,  if: :any_non_nil_value)).to eq expected
      end

      it "should render nothing when #if option is false or nil" do
        ffb = form_field_builder Person.new(name: "Pops")
        expect(fix_field ffb.text_input("name", if: false)).to eq ""
        expect(fix_field ffb.text_input("name", if: nil)).to eq ""
      end

      it "renders nothing when field_filter obstructs" do
        ffb = form_field_builder Person.new(name: "Popeye", sex: "yes", phone: "topsecret"), filter: Person.filter_config

        expect(fix_field ffb.text_input("phone")).to eq ""


        Entity.gdpr = true

        expected = "<li class='input_row person-phone'>
<label class='input-label'>
<span class='label-txt'>Phone</span></label>
<div class='error_container'></div>
<input type='text' name='person[phone]' value='topsecret'/></li>"

        expect(fix_field ffb.text_input("phone")).to eq expected

        Entity.gdpr = false

        expect(fix_field ffb.text_input("phone")).to eq ""
      end

      it "does nothing when #if option is false or nil" do
        ffb = form_field_builder nil, input_name_prefix: 'x', class_name: "contact"
        expect(ffb.text_input(:name, if: nil) ).to eq ""
        expect(ffb.text_input(:name, if: false) ).to eq ""
      end
    end

    it "should escape html in text input" do
      ffb = form_field_builder Person.new(name: "<script src='application.js?id=1&DROP TABLE `users`;'/>")
      v = "&lt;script src=&#39;application.js?id=1&amp;DROP TABLE `users`;&#39;/&gt;"
      input = "<input type='text' name='person[name]' value='#{v}'/>"
      expected = expectable "person-name", "Nom", input
      expect(fix_field ffb.text_input(:name)).to eq expected
    end

    it "uses an alternative attribute for the value" do
      ffb = form_field_builder Person.new(name: "Blogs", city: "Köln")
      input = "<input type='text' name='person[name]' value='Köln'/>"
      expected = expectable "person-name", "Nom", input
      expect(fix_field ffb.text_input(:name, from: :city)).to eq expected
    end

    it "respects value override" do
      ffb = form_field_builder Person.new(name: "Blogs")
      input = "<input type='text' name='person[name]' value='Samuel'/>"
      expected = expectable "person-name", "Nom", input
      expect(fix_field ffb.text_input(:name, value: "Samuel")).to eq expected
    end

    it "should escape html in text input" do
      ffb = form_field_builder Person.new(name: "<Blogs>")
      input = "<input type='text' name='person[name]' value='&lt;Blogs&gt;'/>"
      expected = expectable "person-name", "Nom", input
      expect(fix_field ffb.text_input(:name)).to eq expected
    end

    it "is totally fine with a nil #target" do
      ffb = form_field_builder nil, input_name_prefix: 'x', class_name: "person"
      input = "<input type='text' name='x[name]' value=''/>"
      expected = expectable "x-name", "Nom", input
      expect(fix_field ffb.text_input(:name) ).to eq expected
    end

    it "is totally fine with a nil #target and a value override" do
      ffb = form_field_builder nil, input_name_prefix: 'x', class_name: "person"
      input = "<input type='text' name='x[name]' value='Worgle'/>"
      expected = expectable "x-name", "Nom", input
      expect(fix_field ffb.text_input(:name, value: "Worgle") ).to eq expected
    end
  end
end
