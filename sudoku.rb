class Sudoku
	def initialize(board_string)
		@sudoku_board = []
  	until board_string.length == 0
    		row = board_string.slice!(0, 9).split("")
    		row.map! { |num| num.to_i }
    		@sudoku_board << row
  	end
	end

  def display_board(sboard = @sudoku_board)
    board_string = ""
    sboard.each_with_index do |row, row_index|
      board_string << "-"*21 + "\n" if row_index % 3 == 0
      row.each_with_index do |cell, cell_index|
        board_string << "| " if cell_index % 3 == 0 && cell_index != 0
        board_string << cell.to_s + " "
      end
      board_string << "\n"
    end
    board_string << "-"*21
    return board_string
  end

  def get_empty_cells(sboard)
    empty_cells = []
    sboard.each_with_index do |row, row_index|
      row.each_with_index do |col, column_index|
        value = sboard[row_index][column_index]
        empty_cells << [row_index, column_index] if value == 0
      end
    end
    return empty_cells
  end

  def all_relevent_coordinates(row, column)
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

  def used_numbers(all_relevent_coordinates)
    used = []
    all_relevent_coordinates.each do |section|
      section.each { |coord| used << (@sudoku_board[coord[0]][coord[1]]) }
    end
    return used.uniq
  end

  def possible_numbers(all_relevent_coordinates)
    possibilities = (0..9).to_a
    used = used_numbers(all_relevent_coordinates)
    used.each { |num| possibilities.delete(num) }
    return possibilities
  end

  def solve!
    sboard = @sudoku_board 
    sboard = by_elimination(sboard)
    @sudoku_board = sboard
  end

  def by_elimination(sboard)
    changed = true
    while changed do
      changed = false
      empty_cells = get_empty_cells(sboard)
      empty_cells.each do |coords|
        all_coords = all_relevent_coordinates(coords[0], coords[1])
        possibilities = possible_numbers(all_coords)
        if possibilities.length == 1
          sboard[coords[0]][coords[1]] = possibilities.first
          changed = true
        end
     end
    end
    puts display_board(sboard)
    puts "\n\n"
    sboard = by_common_possibles(sboard) if get_empty_cells(sboard).length > 0
    return sboard
  end

  def by_common_possibles(sboard)
    changed = false
    empty_cells = get_empty_cells(sboard)
    empty_cells.each do |empty_coord|
      break if changed
      all_coords = all_relevent_coordinates(empty_coord[0], empty_coord[1])
      all_coords.each_with_index do |section, i|
        break if changed
        section_coords = all_coords[0]
        empty_section_coords = []
        section_coords.each { |coord| empty_section_coords << coord if sboard[coord[0]][coord[1]] == 0 }
        possibilities_counter = Hash.new
        for num in 1..9 do 
          possibilities_counter[num] = 0 
        end



        empty_section_coords.each do |coords|
          break if changed
          all_coords = all_relevent_coordinates(coords[0], coords[1])
          possibilities = possible_numbers(all_coords)
          possibilities.each do |num| 
            possibilities_counter[num] += 1 
          end
        end

        empty_section_coords.each do |coords|
        break if changed

        if possibilities_counter.has_value?(1)
          possibilities_counter.each do |number, occurances|
            break if changed
            if occurances == 1
              all = all_relevent_coordinates(coords[0], coords[1])
              pos = possible_numbers(all)
              if pos.include?(number)
                sboard[coords[0]][coords[1]] = number
                changed = true
                puts "Row: #{coords[0]}, Column: #{coords[1]}, has been changed to #{number}. #{i}"
                puts pos.to_s
                puts possibilities_counter.to_s
              end
            end
          end
        end

      end

      end
    end
    sboard = by_elimination(sboard) if changed
    return sboard
  end

end

#my_game = Sudoku.new("000070408000401397409820065068007040740109082090600730280016903631502000909040000")
# p "000070408000401397409820065068007040740109082090600730280016903631502000909040000".length => 81
# puts my_game.display_board
# p my_game.show_value(0,0) == 0
# p my_game.show_value(0,4) == 7
# p my_game.show_value(4,3) == 1
# p my_game.show_value(6,6) == 9
# p my_game.show_value(7,4) == 0
# p my_game.all_relevent_coordinates_in_row(1) == [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], [1,8]]
# p my_game.all_relevent_coordinates_in_row(9) #=> raise error
# coords = my_game.all_relevent_coordinates(1,8)
# p coords[0] == [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], [1,8]] # row
# p coords[1] == [[0,8], [1,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8]] # column
# p coords[2] == [[0,6], [0,7], [0,8], [1,6], [1,7], [1,8], [2,6], [2,7], [2,8]] # box
# p my_game.used_numbers([[1,3], [1,5], [1,6], [1,7], [1,8]]) == [4, 1, 3, 9, 7]
# my_game.solve!
# puts my_game.display_board
my_game = Sudoku.new("096040001100060004504810390007950043030080000405023018010630059059070830003590007")
# puts my_game.display_board
my_game.solve!
# puts my_game.display_board
