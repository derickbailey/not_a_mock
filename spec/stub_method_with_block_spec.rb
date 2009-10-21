$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

class BlockTest
	def block_method
		puts "this is the real method. block given? " + block_given?.to_s
		yield if block_given?
	end
end

describe BlockTest, "when stubbing a method with a block, and yielding to that block" do
	before :all do
		bt = BlockTest.new
		
		bt.stub_method(:block_method){ 
			puts 'this is a stub. block given?: ' + block_given?.to_s
			yield if block_given?
		}
		
		@block_executed = false
		bt.block_method() do
			@block_executed = true
		end
	end
	
	it "should execute the block" do
		@block_executed.should be_true
	end
end
