require 'Datavyu_API'

$percent = 0.10

$output_folder = "~/code/work/seedlings/recode_output"



begin
  columns = get_column_list()
  for column in columns
    col = get_column(column)
    annotation_cells = col.cells.select do |elem|
      !elem.object.to_s.start_with? "%"
    end


    n = (annotation_cells.size * $percent).ceil
    start = rand(0..annotation_cells.size-n)
    randrange = annotation_cells.size-1-n
    puts("numcells: #{annotation_cells.size}  randrange: #{randrange}  n: #{n}   start: #{start}   end: #{start+n} ")

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
    save_db(File.join(File.expand_path($output_folder), "#{$pj.getProjectName()}_recode.opf"))
  end


end
