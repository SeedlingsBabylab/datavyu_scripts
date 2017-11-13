require 'Datavyu_API.rb'
require 'rbconfig'
include Config



input_dir = File.expand_path("~/code/work/seedlings/batch_opf_bl/17_chi_2")
output_dir = File.expand_path("~/code/work/seedlings/batch_opf_bl/17_chi_merged_2")




def merge(output)
  child_column = "child_labeled_object"	# set in get_child.rb
  child_col = getColumn(child_column)
  allColumns = getColumnList()
  full_column = allColumns[0]
  full_col = getColumn(full_column)

  original_set = Array.new()
  new_set = Array.new()

  # build list of original ordinals
  for cell in full_col.cells
    if (cell.speaker.to_s == 'CHI') or
      (cell.object.to_s.start_with?("%com: mwu")) or
      (cell.object.to_s.start_with?("%com: first word"))
      original_set.push(cell.ordinal.to_s)
    end
  end



  for child_cell in child_col.cells
    # add to list of new ordinals (what's left after deleting cells)
    new_set.push(child_cell.original_ordinal.to_s)
    if child_cell.original_ordinal.to_s == "NEW"
			new_cell = full_col.make_new_cell()
			full_col.arglist.each do |code|
				new_cell.change_arg(code, child_cell.get_arg(code)) if child_cell.arglist.include?(code)
			end
			new_cell.onset = child_cell.onset
			new_cell.offset = child_cell.offset
		end
    for cell in full_col.cells
      if (child_cell.original_ordinal.to_s == cell.ordinal.to_s)
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

  diff = original_set - new_set # set of deleted cells

  puts diff

  # delete the deleted cells from the original column
  for num in diff
    found = full_col.cells.find{|x| x.ordinal.to_s == num}
    deleteCell(found)
    setColumn(full_col)
  end

  for cell in full_col.cells
    if cell.object.to_s.include?("DELETE")
      deleteCell(cell)
      setColumn(full_col)
    end
  end

  # for child_cell in child_col.cells
  #   for cell in full_col.cells
  #     if (child_cell.onset == cell.onset) && (child_cell.offset == cell.offset)
  #       cell.change_code("object", child_cell.object)
  #       cell.change_code("utterance_type", child_cell.utterance_type)
  #       cell.change_code("object_present", child_cell.object_present)
  #       cell.change_code("speaker", child_cell.speaker)
  #     end
  #   end
  # end
  # setColumn(full_col)
  # deleteVariable(child_column)

  save_db(output)
end


begin
  filenames = Dir.new(input_dir).entries
  for file in filenames
    if file.include?(".opf")
      puts "LOADING DATABASE: " + input_dir+File::SEPARATOR+file
      $db, $pj = load_db(input_dir+File::SEPARATOR+file)
      puts $pj.getProjectName()
      merge(output_dir+File::SEPARATOR+file)
    end
  end

end
