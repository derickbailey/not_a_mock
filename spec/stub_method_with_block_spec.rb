$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

class BlockTest
	def block_method
		puts "this is the real method."
		yield if block_given?
	end
end

describe BlockTest, "when stubbing a method that is called with a block" do
	before :all do
		bt = BlockTest.new

		bt.stub_method(:block_method) {}
		
		@block_executed = false
		bt.block_method(){ @block_executed = true }
	end
	
	it "should execute the block" do
		@block_executed.should be_true
	end
end

