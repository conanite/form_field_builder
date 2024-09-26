require "spec_helper"

RSpec::describe FormFieldBuilder::Plain do
  it "generates a colour-input field" do
    ffb = FormFieldBuilder::Plain.new Person.new
    field = ffb.colour(:eyes)
    expect(field).to eq "<input type='color' name='person[eyes]'/>"
    expect(field).to be_html_safe
  end
end
