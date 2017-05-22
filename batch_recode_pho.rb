require 'Datavyu_API'


$percent = 0.10

$input_dir  = "~/code/work/bergelsonlab/pho_checks_in"
$output_dir = "~/code/work/bergelsonlab/pho_checks_out"


def recode(in_dir, file)
  puts(file)
  $db, $pj = load_db(File.join(in_dir, file))
  columns = get_column_list()
  for column in columns
    col = get_column(column)
    annotation_cells = col.cells.select do |elem|
      elem.object.to_s.start_with? "%pho"
    end
    if annotation_cells.empty?
      next
    end

    n = annotation_cells.size * $percent
    if n < 1
      n = n.ceil
    else
      n = n.round
    end

    start = rand(0..annotation_cells.size-n)
    randrange = annotation_cells.size-1-n
    # puts("numcells: #{annotation_cells.size}  randrange: #{randrange}  n: #{n}   start: #{start}   end: #{start+n} ")


    recode_slice = annotation_cells[start..start+(n-1)]

    new_column = create_new_column("recode_pho", "object",
                                   "utterance_type","object_present",
                                   "speaker")
    for cell in recode_slice
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
    save_db(File.join(File.expand_path($output_dir), file.sub(".opf", "_recode.opf")))

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
