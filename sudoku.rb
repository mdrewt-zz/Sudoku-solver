class Sudoku
	def initialize(board_string)
		@sudoku_board = []
  	until board_string.length == 0
    		row = board_string.slice!(0, 9).split("")
    		row.map! { |num| num.to_i }
    		@sudoku_board << row
        # puts row.to_s => puts each row
  	end
	end

  def display_board
    board_string = ""
    @sudoku_board.each_with_index do |row, row_index|
      board_string << "-"*11 + "\n" if row_index % 3 == 0
      row.each_with_index do |cell, cell_index|
        board_string << "|" if cell_index % 3 == 0 && cell_index != 0
        board_string << cell.to_s
      end
      board_string << "\n"
    end
    board_string << "-"*11
    return board_string
  end

end

my_game = Sudoku.new("000070408000401397409820065068007040740109082090600730280016903631502000909040000")
# puts "000070408000401397409820065068007040740109082090600730280016903631502000909040000".length => 81
puts my_game.display_board