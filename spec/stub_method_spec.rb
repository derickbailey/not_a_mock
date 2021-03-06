$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

describe "A stubbed method replacing an existing instance method" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:length => 42)
  end
  
  it "should return the stubbed result" do
    @object.length.should == 42
  end
  
  it "should return the original result after stubbing is removed" do
    @object.unstub_method(:length)
    @object.length.should == 13
  end
  
  it "should return the original result after a reset" do
    NotAMock::Stubber.instance.reset
    @object.length.should == 13
  end
  
  it "should return the new result if re-stubbed" do
    @object.stub_method(:length => 24)
    @object.length.should == 24
  end
  
  it "should record a call to the stubbed method" do
    @object.length
    NotAMock::CallRecorder.instance.calls.should include(:object => @object, :method => :length, :args => [], :result => 42)
  end
  
  it "should return a call to the stubbed method if re-stubbed" do
    @object.stub_method(:length => 24)
    @object.length
    NotAMock::CallRecorder.instance.calls.should include(:object => @object, :method => :length, :args => [], :result => 24)
  end
  
  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end

end

describe "A stubbed method with no existing instance method" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:blah => 42)
  end
  
  it "should return the stubbed result" do
    @object.blah.should == 42
  end
  
  it "should raise a NoMethodError when the method is called after stubbing is removed" do
    @object.unstub_method(:blah)
    lambda { @object.blah }.should raise_error(NoMethodError)
  end
  
  it "should raise a NoMethodError when the method is called after all stubbing is removed" do
    NotAMock::Stubber.instance.reset
    lambda { @object.blah }.should raise_error(NoMethodError)
  end
  
  it "should record a call to the stubbed method" do
    @object.blah
    NotAMock::CallRecorder.instance.calls.should include(:object => @object, :method => :blah, :args => [], :result => 42)
  end
  
  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
  
end

describe "A stubbed class method" do
  
  before do
    Time.stub_method(:now => 42)
  end
  
  it "should return the stubbed result" do
    Time.now.should == 42
  end
  
  it "should return the original result after stubbing is removed" do
    Time.unstub_method(:now)
    Time.now.should_not == 42
  end
  
  it "should return the original result after a reset" do
    NotAMock::Stubber.instance.reset
    Time.now.should_not == 42
  end

  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
  
end

describe "A stubbed private method" do
  before do
    class Privateer
      private
      
      def self.stubbed
        false
      end
    end
    
    Privateer.stub_method(:stubbed => true)
  end
  
  it "should return the stubbed result" do
    Privateer.send(:stubbed).should be_true
  end
  
  it "should return the original result after stubbing is removed" do
    Privateer.unstub_method(:stubbed)
    Privateer.send(:stubbed).should be_false
  end
  
  it "should return the original result after a reset" do
    NotAMock::Stubber.instance.reset
    Privateer.send(:stubbed).should be_false
  end

  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
end

describe "A stubbed protected method" do
  before :each do
    class Protector
      protected
      
      def self.stubbed
        false
      end
    end
    
    Protector.stub_method(:stubbed => true)
  end
  
  it "should return the stubbed result" do
    Protector.send(:stubbed).should be_true
  end
  
  it "should return the original result after stubbing is removed" do
    Protector.unstub_method(:stubbed)
    Protector.send(:stubbed).should be_false
  end
  
  it "should return the original result after a reset" do
    NotAMock::Stubber.instance.reset
    Protector.send(:stubbed).should be_false
  end

  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
end

describe "A method stubbed with a block" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:length) do |*args|
      args.reverse
    end
  end
  
  it "should return the result of the block" do
    @object.length(1, 2, 3).should == [3, 2, 1]
  end
  
  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
  
end

describe "A method stubbed to raise an exception" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method_to_raise(:length => ArgumentError)
  end

  it "should raise the exception when called" do
    lambda { @object.length }.should raise_error(ArgumentError)  
  end
  
  it "should return the original result after stubbing is removed" do
    @object.unstub_method(:length)
    @object.length.should == 13
  end
  
  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
  
end

describe "Object#stub_method" do
  
  it "should stub a method with a name ending in '?'" do
    @object = "Hello, world!"
    @object.stub_method(:is_great? => true)
    @object.is_great?.should be_true
  end
  
  it "should stub the []= method" do
    @object = Array.new
    @object.stub_method(:[]= => nil)
    @object[0] = 7
    @object.length.should == 0
  end
  
  it "should raise an ArgumentError if called with something other than a symbol or hash" do
    @object = "Hello, world!"
    lambda { @object.stub_method(7) }.should raise_error(ArgumentError)
  end

  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
  
end
