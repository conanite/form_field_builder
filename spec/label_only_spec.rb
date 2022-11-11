require "spec_helper"

RSpec.describe FormFieldBuilder::LabelOnly do
  include FormFieldBuilderHelpers

  describe "some examples in french" do
    before { I18n.locale = :fr }

    it "should render just a label" do
      ffb = label_builder Person.new, tag: "td"
      expected = "<td class='person-name'>
<label class='input-label' for='iNpUtId'>
<span class='label-txt'>Nom</span>
<span class='required'>*</span></label></td>"

      expect(fix_field ffb.label(:name, required: true)).to eq expected
    end

    it "should render just a label even when calling other renderers" do
      ffb = label_builder Person.new, tag: "td"
      expected = "<td class='person-name'>
<label class='input-label' for='iNpUtId'>
<span class='label-txt'>Nom</span>
<span class='required'>*</span></label></td>"

      expect(fix_field ffb.text_input(:name, required: true)).to eq expected
    end

    it "shows a label" do
      ffb = label_builder Person.new(name: "Pops")
      expected = expect_label "person-name", "Nom"
      expect(fix_field ffb.text_input("name")).to eq expected
      expect(fix_field ffb.text_input(:name) ).to eq expected
    end

    describe "filtering" do
      it "should create a text input field with a value and explicit #if option" do
        ffb = label_builder Person.new(name: "Pops")
        expected = expect_label "person-name", "Nom"
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

      it "does nothing when #if option is false or nil" do
        ffb = label_builder nil, input_name_prefix: 'x', class_name: "person"
        expect(ffb.text_input(:name, if: nil) ).to eq ""
        expect(ffb.text_input(:name, if: false) ).to eq ""
      end
    end

    it "should create a money input field with a value" do
      ffb = label_builder Person.new(height: 12.34)
      expected = expect_label "person-height", "Hauteur"
      expect(fix_field ffb.money_input("height")).to eq expected
    end

    it "should create a date input field with a value" do
      ffb = label_builder Person.new(dob: "2013-02-11")
      expected = expect_label "person-dob", "Né(e) le"
      expect(fix_field ffb.date_input("dob")).to eq expected
    end

    it "is totally fine with a nil #target" do
      ffb = label_builder nil, input_name_prefix: 'x', class_name: "person"
      expected = expect_label "x-name", "Nom"
      expect(fix_field ffb.text_input(:name) ).to eq expected
    end

    it "is totally fine with a nil #target and a value override" do
      ffb = label_builder nil, input_name_prefix: 'x', class_name: "person"
      expected = expect_label "x-name", "Nom"
      expect(fix_field ffb.text_input(:name, value: "Worgle") ).to eq expected
    end
  end

  describe "some examples in english" do
    before { I18n.locale = :en }

    it "shows a label" do
      ffb = label_builder Person.new
      expected = expect_label "person-name", "Name"
      expect(fix_field ffb.text_input("name")).to eq expected
      expect(fix_field ffb.text_input(:name) ).to eq expected
    end

    it "ignores override value" do
      ffb = label_builder Person.new(name: "Friggle")
      expected = expect_label "person-name", "Name"
      expect(fix_field ffb.text_input(:name, value: "Fraggle") ).to eq expected
    end

    it "uses a custom label" do
      ffb = label_builder Person.new
      expected = expect_label "person-name", "Wizzy-woo"
      expect(fix_field ffb.text_input(:name, lbl: "Wizzy-woo") ).to eq expected
    end

    it "ignores description" do
      ffb = label_builder Person.new
      expected = expect_label "person-name", "Name"
      expect(fix_field ffb.text_input(:name, description: true)).to eq expected
    end

    it "ignores placeholder" do
      ffb = label_builder Person.new
      expected = expect_label "person-name", "Name"
      expect(fix_field ffb.text_input("name", placeholder: "frubar")).to eq expected
      expect(fix_field ffb.text_input(:name,  placeholder: "frubar")).to eq expected
    end

    it "should not chop off /_id$/ when requested not to" do
      ffb = label_builder Person.new
      expected = expect_label "person-import_id", "Import identifier"
      expect(fix_field ffb.text_input(:import_id, preserve_id_suffix: true)).to eq expected
    end

    it "should create a quantity input field with a value" do
      ffb = label_builder Person.new(fingers: 123)
      expected = expect_label "person-fingers", "Finger count"
      expect(fix_field ffb.quantity_input("fingers")).to eq expected
    end
  end
end
