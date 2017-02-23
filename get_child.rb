require 'Datavyu_API.rb'
begin
	column = "labeled_object"	# set this as necessary
	allColumns = getColumnList()
	column = allColumns[0]
	puts column
	col = getColumn(column)
	child_column = createNewColumn("child_labeled_object", "object","utterance_type","object_present","speaker")
	for cell in col.cells
		if (cell.speaker.to_s == 'CHI') or (cell.object.to_s.start_with?("%com: mwu")) or (cell.object.to_s.start_with?("%com: first word"))
			newcell = child_column.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", cell.utterance_type)
			newcell.change_code("object_present", cell.object_present)
			newcell.change_code("speaker", cell.speaker)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
		end
	end
	setColumn(child_column)
end
