class Sudoku
	def initialize(board_string)
		@sudoku_board = []
  	until board_string.length == 0
    		row = board_string.slice!(0, 9).split("")
    		row.map! { |num| num.to_i }
    		@sudoku_board << row
  	end
	end

  def display_board
    board_string = ""
    @sudoku_board.each_with_index do |row, row_index|
      board_string << "-"*21 + "\n" if row_index % 3 == 0
      row.each_with_index do |cell, cell_index|
        board_string << "| " if cell_index % 3 == 0 && cell_index != 0
        board_string << cell.to_s + " "
      end
      board_string << "\n"
    end
    board_string << "-"*21
    board_string
  end

  def show_value(row, column)
    @sudoku_board[row][column]
  end

  def all_coordinates(row, column)
    raise 'Row out of bounds' unless (0..8).to_a.include?(row)
    raise 'Column out of bounds' unless (0..8).to_a.include?(column)
    row_coords = []
    col_coords = []
    box_coords = []
    for index in 0..8 do
      row_coords << [row, index]
      col_coords << [index, column]
      box_coords << [(row/3)*3 + index/3, (column/3)*3 + index%3]
    end
    return [row_coords, col_coords, box_coords]
  end

  def used_numbers(row_coords, col_coords = [], box_coords = [])
    used = []
    row_coords.each do |coord|
      used << (@sudoku_board[coord[0]][coord[1]])
    end
    col_coords.each do |coord|
      used << (@sudoku_board[coord[0]][coord[1]])
    end
    box_coords.each do |coord|
      used << (@sudoku_board[coord[0]][coord[1]])
    end
    used.uniq
  end

  def solve!
    changed = true
    while changed

      changed = false
      @sudoku_board.map!.with_index do |row, row_index|
        row.map!.with_index do |column, column_index|
          if column == 0
            possibilities = (1..9).to_a
            all_coords = all_coordinates(row_index, column_index)
            used = used_numbers(all_coords[0], all_coords[1], all_coords[2])
            used.each { |num| possibilities.delete(num) }
            if possibilities.length == 1
              column = possibilities.first
              changed = true
              puts "#{row_index}, #{column_index}: #{possibilities.first}"
            end
          end
          column
        end
      end

    end
  end

end

my_game = Sudoku.new("000070408000401397409820065068007040740109082090600730280016903631502000909040000")
# p "000070408000401397409820065068007040740109082090600730280016903631502000909040000".length => 81
puts my_game.display_board
# p my_game.show_value(0,0) == 0
# p my_game.show_value(0,4) == 7
# p my_game.show_value(4,3) == 1
# p my_game.show_value(6,6) == 9
# p my_game.show_value(7,4) == 0
# p my_game.all_coordinates_in_row(1) == [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], [1,8]]
# p my_game.all_coordinates_in_row(9) #=> raise error
# coords = my_game.all_coordinates(1,8)
# p coords[0] == [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], [1,8]] # row
# p coords[1] == [[0,8], [1,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8]] # column
# p coords[2] == [[0,6], [0,7], [0,8], [1,6], [1,7], [1,8], [2,6], [2,7], [2,8]] # box
# p my_game.used_numbers([[1,3], [1,5], [1,6], [1,7], [1,8]]) == [4, 1, 3, 9, 7]
my_game.solve!
puts my_game.display_board


