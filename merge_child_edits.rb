require 'Datavyu_API.rb'



def check_format(child_col)
	found_err = false
	for cell in child_col.cells
		if cell.object.to_s.start_with?("%pho:")
			if cell.onset != cell.offset
				puts("pho cell at ordinal #{cell.ordinal} in child utterance column has mismatched onset/offset")
				found_err = true
			end
		end
	end
	return found_err
end

begin
	child_column_name = "child_labeled_object"	# set in get_child.rb
	child_col = get_column(child_column_name)
	allColumns = get_column_list()
	full_column_name = "labeled_object"
	full_col = get_column(full_column_name)

	original_set = Array.new()
	new_set = Array.new()

	messed_up = check_format(child_col)

	if messed_up
		exit
	end

	for cell in full_col.cells
		if (cell.speaker.to_s == 'CHI') or
			(cell.object.to_s.start_with?("%com: mwu")) or
			(cell.object.to_s.start_with?("%com: first word"))
			original_set.push(cell.ordinal.to_s)
		end
	end

	# puts full_col.cells

	for child_cell in child_col.cells
		new_set.push(child_cell.original_ordinal.to_s)
		if child_cell.original_ordinal.to_s == "NEW"
			new_cell = full_col.make_new_cell(child_cell)
			new_cell.onset = child_cell.onset
			new_cell.offset = child_cell.offset
		end

		for orig_cell in full_col.cells
			# puts orig_cell.ordinal.to_s
			# puts child_cell.original_ordinal.to_s
			# puts child_cell.original_ordinal.to_s == orig_cell.ordinal.to_s
			# puts "\n"
			if child_cell.original_ordinal.to_s == orig_cell.ordinal.to_s
				puts "found a match"
				orig_cell.change_code("object", child_cell.object)
				puts orig_cell.print_all()
				orig_cell.change_code("utterance_type", child_cell.utterance_type)
        		orig_cell.change_code("object_present", child_cell.object_present)
        		orig_cell.change_code("speaker", child_cell.speaker)
				orig_cell.change_code("onset", child_cell.onset)
				orig_cell.change_code("offset", child_cell.offset)
      		end
    	end
  	end

	delete_variable(child_col)
	set_column(full_col)

	diff = original_set - new_set # set of deleted cells

	puts diff

	# delete the deleted cells from the original column
	for num in diff
		found = full_col.cells.find{|x| x.ordinal.to_s == num}
		delete_cell(found)
		set_column(full_col)
	end

end
