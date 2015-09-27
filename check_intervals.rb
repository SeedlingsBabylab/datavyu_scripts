require 'Datavyu_API.rb'

begin
	columns = getColumnList()

	#column = "labeled_object_GC"
	for column in columns
		col = getColumn(column)
		# this makes sure all onsets are < offsets
		scan_for_bad_cells(col)

		for cell in col.cells
			if !cell.object.to_s.start_with?("%com") && (cell.onset == cell.offset)
				puts "intervals ERROR: onset and offset are equal in non-comment cell: [Column] " + column + " [Cell#]: " + cell.ordinal.to_s
			end

		end		
	end
end
