require 'Datavyu_API.rb'
begin
	column = "labeled_object"	# set this as necessary
	allColumns = get_column_list()
	column = allColumns[0]
	puts column
	col = get_column(column)
	child_column = create_new_column("child_labeled_object", "object","utterance_type","object_present","speaker", "cell_number")
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
			newcell.change_code("cell_number", cell.ordinal)

			phocell = child_column.make_new_cell()
			phocell.change_code("object", "%pho:")
			phocell.change_code("utterance_type", "NA")
			phocell.change_code("object_present", "NA")
			phocell.change_code("speaker", "NA")
			phocell.change_code("onset", cell.offset)
			phocell.change_code("offset", cell.offset)
			phocell.change_code("ordinal", cell.ordinal)
			phocell.change_code("cell_number", "NEW")
		end
	end
	set_column(child_column)
end
