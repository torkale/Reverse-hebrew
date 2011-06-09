# coding: utf-8
require 'spec_helper'
describe Scrapping::ReverseHebrew do
  it "identifies hebrew chars in string" do
    Scrapping::ReverseHebrew.is_hebrew?("gרjkhjk").should  == true
  end

  it "identifies non hebrew chars in string" do
    Scrapping::ReverseHebrew.is_hebrew?("jkhjk").should == false
  end

  def test_range(from,to)
    from.upto(to) do |c|
      Scrapping::ReverseHebrew.is_left_alone?(c).should == true
    end
  end

  it "identifies which chars to ignore" do
    test_range "a","z"
    test_range "A","Z"
    test_range "0","9"
    test_range "-","-"
  end

  it "reverses special parenthasis chars" do
    Scrapping::ReverseHebrew.rev_special("}").should == "{"
    Scrapping::ReverseHebrew.rev_special("[").should == "]"
  end

  it "does not ignore other chars" do
      Scrapping::ReverseHebrew.is_left_alone?("<").should == false
  end

  it "reverses hebrew" do
    s = "03/2011 דעומל ,5096 סיטרכ ,012-654-0250618 ןובשח ,יתיא ץרוש בריש "
    Scrapping::ReverseHebrew.reverse_hebrew(s).should == " שירב שורץ איתי, חשבון 012-654-0250618, כרטיס 5096, למועד 03/2011"
  end

  it "reverses words order when numbers are present" do
    s = "108 הל.פיגור"
    Scrapping::ReverseHebrew.reverse_around_number(s).should == "הל.פיגור 108"
    s = "108הלואה-תשל"
    Scrapping::ReverseHebrew.reverse_around_number(s).should == "הלואה-תשל108"
    s = "0570 27/01.ר.רא"
    Scrapping::ReverseHebrew.reverse_around_number(s).should == "ר.רא.27/01 0570"
    s = "00550 הלואה-ריב"
    Scrapping::ReverseHebrew.reverse_around_number(s).should == "הלואה-ריב 00550"
  end

end
