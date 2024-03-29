require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  describe "some examples in english" do
    before { I18n.locale = :en }

    it "takes texts from a given #texts option" do
      ffb = form_field_builder Person.new
      expected = <<EXPECTED
<li class='input_row person-name'>
<label class='input-label' for='iNpUtId'>
<span class='label-txt'>the label of the name of the person</span></label>
<p class='description'>the description of the name of the person</p>
<input type='text' name='person[name]' value='' placeholder='the placeholder of the name of the person' id='iNpUtId'/>
<div class='error_container'></div></li>
EXPECTED
      actual = fix_field ffb.text_input(:name, texts: :fake, description: true, placeholder: true)

      expect(actual).to eq expected.strip
    end

    it "should create a text input field with no value" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      expected = expectable "person-name", "Name", input
      expect(fix_field ffb.text_input("name")).to eq expected
      expect(fix_field ffb.text_input(:name) ).to eq expected
    end

    it "should create a text input field with an override value" do
      ffb = form_field_builder Person.new(name: "Friggle")
      input = "<input type='text' name='person[name]' value='Fraggle' id='iNpUtId'/>"
      expected = expectable "person-name", "Name", input
      expect(fix_field ffb.text_input(:name, value: "Fraggle") ).to eq expected
    end

    it "should create a text input field with a custom label" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      expected = expectable "person-name", "Wizzy-woo", input
      expect(fix_field ffb.text_input(:name, label: "Wizzy-woo") ).to eq expected
    end

    it "looks up description from i18n glossary" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      desc = "<p class='description'>The name of the person</p>"
      expected = expectable "person-name", "Name", input, desc
      expect(fix_field ffb.text_input(:name, description: true)).to eq expected
    end

    it "uses a literal description parameter" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      desc = "<p class='description'>to spam you</p>"
      expected = expectable "person-name", "Name", input, desc
      expect(fix_field ffb.text_input(:name, desc: "to spam you")).to eq expected
    end

    it "literal description overrides i18n" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      desc = "<p class='description'>to warn you</p>"
      expected = expectable "person-name", "Name", input, desc
      expect(fix_field ffb.text_input(:name, desc: "to warn you", description: true)).to eq expected
    end

    it "uses a hash description parameter with language keys" do
      I18n.locale = :fr
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      desc = "<p class='description'>pour vous spammer</p>"
      expected = expectable "person-name", "Nom", input, desc
      expect(fix_field ffb.text_input(:name, desc: { en: "to wish you well", fr: "pour vous spammer" })).to eq expected
    end

    it "should create a text input field with a placeholder" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' placeholder='frubar' id='iNpUtId'/>"
      expected = expectable "person-name", "Name", input
      expect(fix_field ffb.text_input("name", placeholder: "frubar")).to eq expected
      expect(fix_field ffb.text_input(:name,  placeholder: "frubar")).to eq expected
    end

    it "should create a text input field with a placeholder from i18n" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' placeholder='smith' id='iNpUtId'/>"
      expected = expectable "person-name", "Name", input
      expect(fix_field ffb.text_input(:name,  placeholder: true)).to eq expected
    end

    it "should not chop off /_id$/ when requested not to" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[import_id]' value='' id='iNpUtId'/>"
      expected = expectable "person-import_id", "Import identifier", input
      expect(fix_field ffb.text_input(:import_id, preserve_id_suffix: true)).to eq expected
    end

    it "inserts extra element attributes" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='person[name]' value='' id='iNpUtId'/>"
      expected = expectable "person-name", "Name", input, nil, "li", " data-foo='unbedingt' onmouseover='jump!'"
      expect(fix_field ffb.text_input(:name, tag_attributes: { :"data-foo" => "unbedingt", onmouseover: "jump!"})).to eq expected
    end

    it "overrides field nane" do
      ffb = form_field_builder Person.new
      input = "<input type='text' name='whatever!' value='' id='iNpUtId'/>"
      expected = expectable "person-name", "Name", input
      expect(fix_field ffb.text_input(:name, field_name: "whatever!")).to eq expected
    end
  end
end
