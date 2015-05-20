require 'Datavyu_API.rb'

begin

	column = "labeled_object_GC"

	col = getColumn(column)

	# this makes sure all onsets are < offsets
	scan_for_bad_cells(col)
	
end
