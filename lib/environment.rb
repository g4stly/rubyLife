class Environment
	## cell definition
	class Cell
		attr_accessor :alive

		def initialize alive
			@alive = false
			if alive then @alive = true end
		end

		def update_neighbors count
			@neighbors = count
		end

		def check_neighbors
			if @neighbors < 2 then return false end
			if @neighbors > 3 then return false end
			if @neighbors == 2 then return @alive end
			true
		end

		def character
			(@alive = check_neighbors) ? '*' : ' '
		end

	end

	## rest of environment definition
	def initialize height, width

		@height = height
		@width = width
		@frame = Array.new(@width * @height)

		# see updateNeighbors for usage of translations
		@translations = [
			-@width-1,
			-@width,
			-@width+1,

			-1, +1,
			@width-1,
			@width,
			@width+1
		]

		# populate randomly for now
		prng = Random.new
		(0...height*width).each do |i|
			@frame[i] = Cell.new((prng.rand(100) % 2) == 1)
		end
	end

	def updateNeighbors index
		neighbor_count = 0
		@translations.each do |translation|
			# check for out of bounds
			if index + translation < 0 then next end
			if index + translation >= @width*@height then next end

			# target = the cell we want to check
			target = index + translation
			target_modulo = target % @width
	
			# will be true if the current cell
			# is on the left or right edge respectively
			left_edge = (index % @width == 0)
			right_edge = (index % @width == @width-1)

			# confirm we are not referencing alive cells
			# from the opposite edge of the board as neighbors
			if right_edge && target_modulo == 0 then next end
			if left_edge && target_modulo == @width -1 then next end

			# finally, if the target cell is alive, count it as a neighbor
			if @frame[target].alive then neighbor_count += 1 end
		end
		@frame[index].update_neighbors neighbor_count
	end

	def step
		frame = []
		# first pass update all neighbors
		(0...@width * @height).each do |index|
			updateNeighbors index
		end
		# second pass, ask for a character to draw for that cell
		# this will force the cell to reference it's neighbors
		# and decide if it needs to live or die
		@frame.each do |cell|
			frame << cell.character
		end
		frame
	end

	private :updateNeighbors
end

