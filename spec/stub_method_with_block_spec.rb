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

describe BlockTest, "when stubbing a method that is called with a block" do
	before :all do
		@bt = BlockTest.new

		@bt.stub_method(:block_method) {}
		
		@block_executed = false
		@bt.block_method(){ @block_executed = true }
	end
	
	it "should execute the block" do
		@block_executed.should be_true
	end
	
	it "should not call the real method" do
		@bt.real_method_called.should be_false
	end
end

describe BlockTest, "when stubbing a method that yields two values" do
	before :all do
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
end
