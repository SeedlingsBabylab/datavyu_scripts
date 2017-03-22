require 'Datavyu_API.rb'
require 'rbconfig'
include Config



input_dir = File.expand_path("~/code/work/seedlings/batch_merge_opf")
output_dir = File.expand_path("~/code/work/seedlings/opf_merge_out")




def merge(output)
  puts "hello"
  child_column = "child_labeled_object"	# set in get_child.rb
  child_col = getColumn(child_column)
  allColumns = getColumnList()
  full_column = allColumns[0]
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
