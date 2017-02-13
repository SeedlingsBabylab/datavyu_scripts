require 'Datavyu_API.rb'
begin
	child_column = "child_labeled_object"	# set this as necessary
	child_col = getColumn(child_column)
	full_column = "labeled_object"
	full_col = getColumn(full_column)
	for child_cell in child_col.cells
		for cell in full_col.cells
			if (child_cell.onset == cell.onset) && (child_cell.offset == cell.offset)
				cell.change_code("object", child_cell.object)
				cell.change_code("utterance_type", child_cell.utterance_type)
        cell.change_code("object_present", child_cell.object_present)
        cell.change_code("speaker", child_cell.speaker)
      end
    end
  end
  setColumn(full_col)
  deleteVariable(child_column)
end
