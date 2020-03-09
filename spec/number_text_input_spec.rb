require "spec_helper"

RSpec::describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  describe "some examples in french" do
    before { I18n.locale = :fr }

    it "creates a money input field with a value" do
      ffb = form_field_builder Person.new(height: 12.34)
      input = "<input class='numeric money' type='text' name='person[height]' value='12,34'/>"
      expected = expectable "person-height", "Hauteur", input
      expect(fix_field ffb.money_input("height")).to eq expected
    end

    it "creates a money input field with a placeholder" do
      ffb = form_field_builder Person.new(height: 12.34)
      input = "<input class='numeric money' type='text' name='person[height]' value='12,34' placeholder='expensive'/>"
      expected = expectable "person-height", "Hauteur", input
      expect(fix_field ffb.money_input("height", placeholder: "expensive")).to eq expected
    end

    it "creates a money input field with a value and a custom label" do
      ffb = form_field_builder Person.new(height: 12.34)
      input = "<input class='numeric money' type='text' name='person[height]' value='12,34'/>"
      expected = expectable "person-height", "Le montant que je veux que tu me payes", input
      expect(fix_field ffb.money_input("height", lbl: "Le montant que je veux que tu me payes")).to eq expected
    end

    it "creates a money input field with a value and a translated custom label" do
      ffb = form_field_builder Person.new(height: 12.34)
      input = "<input class='numeric money' type='text' name='person[height]' value='12,34'/>"
      expected = expectable "person-height", "Grande ?", input
      expect(fix_field ffb.money_input("height", lbl: { fr: "Grande ?", en: "Tall?"})).to eq expected
    end

    it "should create a quantity input field with a value" do
      ffb = form_field_builder Person.new(fingers: 12345)
      input = "<input class='numeric' type='text' name='person[fingers]' value='12345'/>"
      expected = expectable "person-fingers", "Nombre de doigts", input
      expect(fix_field ffb.quantity_input("fingers")).to eq expected
    end

    it "should create a decimal input field with a value" do
      ffb = form_field_builder Person.new(height: 1024.5)
      input = "<input class='numeric' type='text' name='person[height]' value='1 024,5'/>"
      expected = expectable "person-height", "Hauteur", input
      expect(fix_field ffb.decimal_input("height")).to eq expected
    end

    it "should create a numeric input field with a value" do
      ffb = form_field_builder Person.new(fingers: "1024")
      input = "<input class='numeric' type='text' name='person[fingers]' value='1024'/>"
      expected = expectable "person-fingers", "Nombre de doigts", input
      expect(fix_field ffb.integer_input("fingers")).to eq expected
    end

    it "should create a decimal input field with an integer value" do
      ffb = form_field_builder Person.new(height: "2")
      input = "<input class='numeric' type='text' name='person[height]' value='2'/>"
      expected = expectable "person-height", "Hauteur", input
      expect(fix_field ffb.decimal_input("height")).to eq expected
    end

    it "should create a decimal input field with 3-decimal-place value" do
      ffb = form_field_builder Person.new(height: 2.345)
      input = "<input class='numeric' type='text' name='person[height]' value='2,345'/>"
      expected = expectable "person-height", "Hauteur", input
      expect(fix_field ffb.decimal_input("height")).to eq expected
    end
  end

  describe "some examples in english" do
    before { I18n.locale = :en }

    it "should create a quantity input field with a value" do
      ffb = form_field_builder Person.new(fingers: 12345)
      input = "<input class='numeric' type='text' name='person[fingers]' value='12345'/>"
      expected = expectable "person-fingers", "Finger count", input
      expect(fix_field ffb.quantity_input("fingers")).to eq expected
    end

    it "should create a decimal input field with a value" do
      ffb = form_field_builder Person.new(height: 1024.5)
      input = "<input class='numeric' type='text' name='person[height]' value='1,024.5'/>"
      expected = expectable "person-height", "Tallness", input
      expect(fix_field ffb.decimal_input("height")).to eq expected
    end
  end
end
