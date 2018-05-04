require "spec_helper"

RSpec.describe FormFieldBuilder::Decorated do
  include FormFieldBuilderHelpers

  describe "some examples in french" do
    before { I18n.locale = :fr }

    it "should create a textarea field with a value" do
      ffb = form_field_builder Person.new(bio: "Googy boogy\nfudge wudge\ntinkle winkle")
      input = "<textarea name='person[bio]' rows='6'>Googy boogy&#x000A;fudge wudge&#x000A;tinkle winkle</textarea>"
      expected = expectable "person-bio", "Biographie", input
      expect(fix_field ffb.text_area(:bio)).to eq expected
    end

    it "should create a textarea field with a value, rows, and placeholder" do
      ffb = form_field_builder Person.new(bio: "Googy boogy\nfudge wudge\ntinkle winkle")
      input = "<textarea name='person[bio]' rows='12' placeholder='bingo'>Googy boogy&#x000A;fudge wudge&#x000A;tinkle winkle</textarea>"
      expected = expectable "person-bio", "Biographie", input
      expect(fix_field ffb.text_area(:bio, rows: 12, placeholder: "bingo")).to eq expected
    end

    it "should escape html in textarea" do
      malicious_text = "<script src='application.js?id=1&DROP TABLE `users`;'/>Googy boogy\nfudge wudge\ntinkle winkle"
      ffb = form_field_builder Person.new(bio: malicious_text)

      v = "&lt;script src=&#39;application.js?id=1&amp;DROP TABLE `users`;&#39;/&gt;Googy boogy&#x000A;fudge wudge&#x000A;tinkle winkle"
      input = "<textarea name='person[bio]' rows='6'>#{v}</textarea>"
      expected = expectable "person-bio", "Biographie", input
      expect(fix_field ffb.text_area(:bio)).to eq expected
    end
  end
end
