require 'Datavyu_API'

$percent = 0.10

$input_dir  = "~/code/work/seedlings/reliability_data/batch_recode_in"
$output_dir = "~/code/work/seedlings/reliability_data/batch_recode_out"
$original_out = "~/code/work/seedlings/reliability_data/batch_recode_orig_out"




def recode(in_dir, file)
  puts(file)
  $db, $pj = load_db(File.join(in_dir, file))
  columns = get_column_list()
  for column in columns
    col = get_column(column)


    annotation_cells = col.cells.select do |elem|
      (!elem.object.to_s.start_with? "%") && !(elem.speaker.to_s == "CHI")
    end

    chi_cells = col.cells.select do |elem|
      elem.speaker == "CHI"
    end

    old_n = (annotation_cells.size * $percent).ceil
    not_n = (chi_cells.size * $percent).ceil
    n = old_n - not_n

    start = rand(0..annotation_cells.size-n)
    randrange = annotation_cells.size-1-n
    puts("numcells: #{annotation_cells.size}  numchicells: #{chi_cells.size}   randrange: #{randrange}  n: #{n}  not_n: #{not_n}  old_n: #{old_n}   start: #{start}   end: #{start+n} ")

    recode_slice = annotation_cells[start..start+(n-1)]


    # output the blank recode opf's
    new_column = create_new_column("recode", "object", "utterance_type","object_present","speaker", "original_ordinal")
    # new_column = create_new_column("recode", "object", "utterance_type","object_present","speaker", "id", "original_ordinal")
    for cell in recode_slice
      newcell = new_column.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", "")
			newcell.change_code("object_present", "")
			newcell.change_code("speaker", cell.speaker)
      # newcell.change_code("id", cell.id)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
      newcell.change_code("original_ordinal", cell.ordinal)
    end

    set_column(new_column)
    delete_variable(col)
    save_db(File.join(File.expand_path($output_dir), file.sub(".opf", "_recode.opf")))
    delete_variable(new_column)



    # output the original annotations to a separate opf
    new_column = create_new_column("recode", "object", "utterance_type","object_present","speaker", "original_ordinal")
    # new_column = create_new_column("recode", "object", "utterance_type","object_present","speaker", "id", "original_ordinal")
    for cell in recode_slice
      newcell = new_column.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", cell.utterance_type)
			newcell.change_code("object_present", cell.object_present)
			newcell.change_code("speaker", cell.speaker)
      # newcell.change_code("id", cell.id)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
      newcell.change_code("original_ordinal", cell.ordinal)
    end

    set_column(new_column)
    save_db(File.join(File.expand_path($original_out), file.sub(".opf", "_recode_orig.opf")))

  end
end



begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with? ".opf"
      recode(in_dir, file)
    end
  end
end
