require 'Datavyu_API'

$percent = 0.10

$input_dir  = "~/code/work/seedlings/batch_recode_in"
$output_dir = "~/code/work/seedlings/batch_recode_out"




def recode(file)
  puts(file)
  $db, $pj = load_db(file)
  columns = get_column_list()
  for column in columns
    col = get_column(column)
    n = col.cells.size * $percent
    annotation_cells = col.cells.select do |elem|
      !elem.object.to_s.start_with? "%"
    end


    n = (annotation_cells.size * $percent).ceil
    start = rand(0..annotation_cells.size-n)
    # randrange = annotation_cells.size-1-n

    recode_slice = annotation_cells[start..start+(n-1)]

    new_column = create_new_column("recode", "object", "utterance_type","object_present","speaker")
    for cell in recode_slice
      newcell = new_column.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", "")
			newcell.change_code("object_present", "")
			newcell.change_code("speaker", cell.speaker)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
    end

    set_column(new_column)
    delete_variable(col)
    save_db(File.join(File.expand_path($output_dir), "#{$pj.getProjectName()}_recode.opf"))
    # save_db($out_file)
  end
end



begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with? ".opf"
      recode(File.join(in_dir, file))
    end
  end
end
