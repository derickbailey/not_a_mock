require 'singleton'

module NotAMock
	class StubMethod
		attr_accessor :yield_values, :return_block
		
		def initialize(&block)
			@block = block
			@yield_values = []
		end
		
		def yields(*args)
			@yield_values = args
		end
		
		def execute_return_block(*args)
			return_value = nil
			(return_value = @block.call(*args)) unless @block.nil?
			return_value
		end
	end
end