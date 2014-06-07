class Sudoku
	def initialize(board_string)
		@sudoku_board = []
  	until board_string.length == 0
    		row = board_string.slice!(0, 9).split("")
    		row.map! { |num| num.to_i}
    		@sudoku_board << row
  	end
	end
  
end

my_game = Sudoku.new("000070408000401397409820065068007040740109082090600730280016903631502000909040000")
#puts "000070408000401397409820065068007040740109082090600730280016903631502000909040000".length => 81