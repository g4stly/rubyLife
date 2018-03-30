require "curses"
class Display
	attr_accessor :height
	attr_accessor :width

	def initialize
		Curses.init_screen
		@height = Curses.lines
		@width = Curses.cols
		@window = Curses::Window.new(@height, @width, 0, 0)
	end
	def draw frame
		@window.clear
		frame.each_with_index do |c, i|
			@window.setpos(i / @width, i % @width)
			@window.addch(c)
		end
		@window.refresh
	end
	def break?
		input = @window.getch
		if input == 'q' then return true end
		false
	end
	def destroy
		Curses.close_screen
	end

	def self.Init(&block)
		display = Display.new
		begin
			yield display
		ensure
			display.destroy
		end
	end
end
