#!/usr/bin/ruby
require "./lib/display"
require "./lib/environment"

# simple game of life implementation
# (c) michael wilson 2018

Display.Init do |display|
	petri_dish = Environment.new display.height, display.width
	loop do
		# step returns an arary of chars to draw
		# after stepping logic by one frame
		display.draw(petri_dish.step)
		if display.break? then break end
	end	
end
