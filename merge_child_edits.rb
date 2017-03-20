require 'Datavyu_API.rb'
begin
	child_column_name = "child_labeled_object"	# set in get_child.rb
	child_col = getColumn(child_column_name)
	allColumns = getColumnList()
	full_column_name = allColumns[0]
	full_col = getColumn(full_column_name)
	for child_cell in child_col.cells
		for cell in full_col.cells
			if (child_cell.cell_number.to_s == cell.ordinal.to_s)
				cell.change_code("object", child_cell.object)
				cell.change_code("utterance_type", child_cell.utterance_type)
        cell.change_code("object_present", child_cell.object_present)
        cell.change_code("speaker", child_cell.speaker)
				cell.change_code("onset", child_cell.onset)
				cell.change_code("offset", child_cell.offset)
      end
    end
  end
	deleteVariable(child_col)
  setColumn(full_col)
end
