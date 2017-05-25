require 'Datavyu_API'

$percent = 0.10

$output_dir = "~/code/work/seedlings/recode_output"



begin
  columns = get_column_list()
  for column in columns
    col = get_column(column)

    annotation_cells = col.cells.select do |elem|
      elem.object.to_s.start_with? "%pho"
    end

    if annotation_cells.empty?
      next
    end

    n = (annotation_cells.size * $percent).ceil
    start = rand(0..annotation_cells.size-n)
    randrange = annotation_cells.size-1-n
    puts("numcells: #{annotation_cells.size}  randrange: #{randrange}  n: #{n}   start: #{start}   end: #{start+n} ")

    recode_slice = annotation_cells[start..start+(n-1)]

    new_column = create_new_column("recode_pho", "object", "utterance_type","object_present","speaker")
    for cell in recode_slice
      parent = col.cells[cell.ordinal-2]
      parent_chi = new_column.make_new_cell()
      parent_chi.change_code("object", parent.object)
      parent_chi.change_code("utterance_type", "NA")
      parent_chi.change_code("object_present", "NA")
      parent_chi.change_code("speaker", parent.speaker)
      parent_chi.change_code("onset", parent.onset)
      parent_chi.change_code("offset", parent.offset)


      newcell = new_column.make_new_cell()
      newcell.change_code("object", "%pho: ")
      newcell.change_code("onset", cell.onset)
      newcell.change_code("offset", cell.offset)

      newcell.change_code("utterance_type", "NA")
      newcell.change_code("speaker", "NA")
      newcell.change_code("object_present", "NA")
    end

    for colu in columns
      delete_variable(colu)
    end
    set_column(new_column)
    save_db(File.join(File.expand_path($output_dir), "#{$pj.getProjectName()}_recode.opf"))

  end

end
