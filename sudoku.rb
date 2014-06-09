class Sudoku
  attr_reader :sudoku_board
	def initialize(board_string)
		@sudoku_board = []
  	until board_string.length == 0
    		row = board_string.slice!(0, 9).split("")
    		row.map! { |num| num.to_i }
    		@sudoku_board << row
  	end
    @sudoku_board.map! do |row|
      row.map! do |column|
        column = [column] if column > 0
        column = (1..9).to_a if column == 0
        column
      end
    end
	end

  def display_board(sboard = @sudoku_board)
    board_string = ""
    sboard.each_with_index do |row, row_index|
      board_string << "-"*21 + "\n" if row_index % 3 == 0
      row.each_with_index do |cell, cell_index|
        board_string << "| " if cell_index % 3 == 0 && cell_index != 0
        board_string << cell.first.to_s + " " if cell.length == 1
        board_string << "0" + " " if cell.length > 1
      end
      board_string << "\n"
    end
    board_string << "-"*21
    return board_string
  end

  def relevant_coords(coord)
    row_coords = []
    col_coords = []
    box_coords = []
    for index in 0..8 do
      row_coords << [coord[0], index]
      col_coords << [index, coord[1]]
      box_coords << [(coord[0]/3)*3 + index/3, (coord[1]/3)*3 + index%3]
    end
    return [row_coords, col_coords, box_coords]
  end

  def solve!
    @sudoku_board = eliminate_contridictions(@sudoku_board)
  end

  def eliminate_contridictions(sboard)
    changed = 0
    unsolved = 0
    new_sboard = sboard
    sboard.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        if col.length == 1
          relevant_coords([row_index, col_index]).each do |group|
            group.each do |coord|
              unless coord == [row_index, col_index]
                if new_sboard[coord[0]][coord[1]].include?(col.first)
                  new_sboard[coord[0]][coord[1]].delete(col.first)
                  changed += 1
                end
              end
            end
          end
        elsif col.length > 1
          unsolved += 1
        elsif col.length == 0
          return -1
        end
      end
    end
    if changed > 0 
      return eliminate_contridictions(new_sboard)
    elsif unsolved > 0
      return elimination_on_numbers(new_sboard)
    else
      return new_sboard
    end
  end

  def elimination_on_numbers(sboard)
    puts "looking!"
    changed = 0
    new_sboard = sboard
    sboard.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        relevant_coords([row_index, col_index]).each do |group|
          group.each do |cell|
            counter = {}
            cell.each do |possible_number|
              counter[possible_number] ||= 0
              counter[possible_number] += 1
            end
            puts counter.to_s
            counter.each do |number, count|
              if count == 1 && sboard[row_index, col_index].include?(number)
                puts "found!"
                new_sboard[row_index, col_index] = [number]
                changed += 1
              end
            end
          end
        end
      end
    end
    if changed > 0 
      return eliminate_contridictions(new_sboard)
    # elsif unsolved > 0
    #   return elimination_on_numbers(new_sboard)
    end
    return new_sboard
  end

  def guess(sboard)
    empty_cells = get_empty_cells(sboard)
    temp_board = sboard
    
    return temp_board
  end

end

my_game = Sudoku.new("000689100800000029150000008403000050200005000090240801084700910500000060060410000")
# p "000070408000401397409820065068007040740109082090600730280016903631502000909040000".length => 81
# puts my_game.display_board
# p my_game.show_value(0,0) == 0
# p my_game.show_value(0,4) == 7
# p my_game.show_value(4,3) == 1
# p my_game.show_value(6,6) == 9
# p my_game.show_value(7,4) == 0
# p my_game.relevant_coords_in_row(1) == [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], [1,8]]
# p my_game.relevant_coords_in_row(9) #=> raise error
# coords = my_game.relevant_coords([1,8])
# p coords[0].to_s
# p coords[0] == [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7]] # row
# p coords[1] == [[0,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8]] # column
# p coords[2] == [[0,6], [0,7], [0,8], [1,6], [1,7], [2,6], [2,7], [2,8]] # box
# p my_game.used_numbers([[[1,3], [1,5], [1,6], [1,7], [1,8]]], my_game.sudoku_board) == [4, 1, 3, 9, 7]
# my_game.solve!
# puts my_game.display_board
#my_game = Sudoku.new("302609005500730000000000900000940000000000109000057060008500006000000003019082040")
#puts my_game.display_board
my_game.solve!
puts "\n"
puts my_game.display_board
