require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Precssious do
  describe :process do
    it "should handle regular styles" do
      Precssious.process(%Q(
        a { 
          color: black;
          text-decoration: none;
        }
      )).should == "a { color: black; text-decoration: none; }"
    end
  
    it "should handle nested styles" do
      Precssious.process(%Q(
        a {
          b {
            color: blue;
          }
        }
      )).should == "a b { color: blue; }"
    end
  
    it "should handle mixed nested and regular styles" do
      Precssious.process(%Q(
        a {
          color: black;
        
          b { color: blue; }
        }
      )).should == "a { color: black; }\na b { color: blue; }"
    end
  
    it "should handle listed (comma delimited) styles" do
      Precssious.process(%Q(
        a, b {
          c {
            font-weight: bold;
          }
        }
      )).should == "a c, b c { font-weight: bold; }"
    end
  
    it "should handle nested listed styles" do
      Precssious.process(%Q(
        a, b {
          c, d {
            font-weight: bold;
          }
        }
      )).should == "a c, a d, b c, b d { font-weight: bold; }"
    end
  
    it "should provide a reverse-order nesting using <>" do
      Precssious.process(%Q(
        a {
          .outer <> { color: red; }
        }
      )).should == ".outer a { color: red; }"
    end
  
    it "should handle pseudoclasses" do
      Precssious.process(%Q(
        a { .to_movie1:hover { background-position: 0 -96px; } }
      )).should == "a .to_movie1:hover { background-position: 0 -96px; }"
    end
  
    it "should handle regular listed classes" do
      Precssious.process(%Q(
        html, body { height: 100%; background: #c0c0c0; text-aling: center; }
      )).should == "html, body { height: 100%; background: #c0c0c0; text-aling: center; }"
    end
  
    it "should allow for nested pseudoclass selectors" do
      Precssious.process(%Q(
        a { -:hover { text-decoration: underline; } }
      )).should == "a:hover { text-decoration: underline; }"
    end
  
    it "should allow nesting on arbitrary 'same-selector' basis" do
      Precssious.process(%Q(
        img {
          -.mood1 { background-position: 0 0; }
          -.mood2 { background-position: -70px 0; }
        }
      )).should == "img.mood1 { background-position: 0 0; }\nimg.mood2 { background-position: -70px 0; }"
    end

    it "should allow nesting on arbitrary 'same-selector' basis, with nesting" do
      Precssious.process(%Q(
        img, p {
          -.mood1 { background-position: 0 0; }
          -.mood2 { background-position: -70px 0; }
        }
      )).should == "img.mood1, p.mood1 { background-position: 0 0; }\nimg.mood2, p.mood2 { background-position: -70px 0; }"
    end
  
    it "should ignore CSS comments" do
      Precssious.process(%Q(
        /* Prestyle comment. */
        a { 
          color: black; /* One in here, too */
          text-decoration: none;
        }
      )).should == "a { color: black; text-decoration: none; }"
    end
  
    it "should allow a special [ie6] selector" do
      Precssious.process(%Q(
        [ie6] a { 
          color: black;
          text-decoration: none;
        }
      )).should == "a { color: black; text-decoration: none; }"
    end
  end
end
