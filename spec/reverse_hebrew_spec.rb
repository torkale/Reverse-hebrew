# coding: utf-8
require 'rspec'
require "../lib/reverse_hebrew.rb"
describe ReverseHebrew do
  it "identifies hebrew chars in string" do
    ReverseHebrew.is_hebrew?("gרjkhjk").should  == true
  end

  it "identifies non hebrew chars in string" do
    ReverseHebrew.is_hebrew?("jkhjk").should == false
  end

  def test_range(from,to)
    from.upto(to) do |c|
      ReverseHebrew.is_left_alone?(c).should == true
    end
  end

  it "identifies which chars to ignore" do
    test_range "a","z"
    test_range "A","Z"
    test_range "0","9"
    test_range "-","-"
  end

  it "reverses special parenthasis chars" do
    ReverseHebrew.rev_special("}").should == "{"
    ReverseHebrew.rev_special("[").should == "]"
  end

  it "does not ignore other chars" do
    ReverseHebrew.is_left_alone?("<").should == false
  end

  it "reverses hebrew" do
    s = "בית קטן בערבה, מס 123, מיקוד 1010, ת.ד. 202"
    ReverseHebrew.reverse_hebrew(s).should == "202 .ד.ת ,1010 דוקימ ,123 סמ ,הברעב"
  end

  it "reverses words order when numbers are present" do
    s = "108 א.ב"
    ReverseHebrew.reverse_around_number(s).should == "א.ב 108"
    s = "108א-ב"
    ReverseHebrew.reverse_around_number(s).should == "א-ב108"
    s = "0570 27/01.א.ב"
    ReverseHebrew.reverse_around_number(s).should == "א.ב.27/01 0570"
    s = "00550 א-ב"
    ReverseHebrew.reverse_around_number(s).should == "א-ב 0055"
  end

end
