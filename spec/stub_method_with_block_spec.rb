$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

class BlockTest
	attr_accessor :real_method_called
	
	def initialize
		@real_method_called = false
	end
	
	def block_method
		@real_method_called = true
	end
	
	def method_that_yields_a_value
		yield false if block_given?
	end
end

module YieldingObject
	def self.yield_test
		obj = YieldedObject.new
		yield obj if block_given?
	end
end

class YieldedObject
	def yielding_test(arg)
		puts "#{arg}"
	end
end

class YieldTest
	def do_something
		YieldingObject.yield_test do |obj|
			obj.yielding_test "foo"
		end
	end
end

describe NotAMock::Stubber, "when stubbing a method that is called with a block" do
	before :each do
		@bt = BlockTest.new

		@bt.stub_method(:block_method)
		
		@block_executed = false
		@bt.block_method(){ @block_executed = true }
	end
	
	after :each do
		NotAMock::Stubber.instance.reset
	end
	
	it "should execute the block" do
		@block_executed.should be_true
	end
	
	it "should not call the real method" do
		@bt.real_method_called.should be_false
	end
	
	it "should track the method call" do
		@bt.should have_received(:block_method)
	end
end

describe NotAMock::Stubber, "when stubbing a method that yields two values" do
	before :each do
		@bt = BlockTest.new

		p = proc { yield false if block_given?}
		@output = @bt.stub_method(:method_that_yields_a_value, &p).yields(true, 2) 
		
		@bt.method_that_yields_a_value(){ |b, i| 
			@yielded_bool = b
			@yielded_int = i
		}
	end
	
	it "should yield the first value" do
		@yielded_bool.should be_true
	end
	
	it "should yield the second value" do
		@yielded_int.should == 2
	end
	
	it "should track the method call" do
		@bt.should have_received(:method_that_yields_a_value)
	end
end 

describe NotAMock::Stubber, "when stubbing a method on an object that is yielded to a block" do
	before :each do
		@stubyielded = YieldedObject.new
		@stubyielded.stub_method(:yielding_test)
		
		YieldingObject.stub_method(:yield_test).yields(@stubyielded)
		
		@yieldtest = YieldTest.new
		@yieldtest.do_something
	end
	
	it "should track the method call on the yielded object" do
		@stubyielded.should have_received(:yielding_test)
	end
	
	it "should track the method call on the yielding object" do
		YieldingObject.should have_received(:yield_test)
	end
end