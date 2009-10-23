require 'singleton'

module NotAMock
	class Yielder
		attr_accessor :yield_values
		
		def initialize
			@yield_values = []
		end
		
		def yields(*args)
			@yield_values = args
		end
	end
end