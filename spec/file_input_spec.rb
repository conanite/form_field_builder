require "spec_helper"

RSpec::describe FormFieldBuilder::Plain do
  it "generates a file-input field" do
    ffb = FormFieldBuilder::Plain.new Person.new
    field = ffb.file(:photo)
    expect(field).to eq "<input type='file' name='person[photo]'/>"
    expect(field).to be_html_safe
  end
end
