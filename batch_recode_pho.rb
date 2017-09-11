require 'Datavyu_API'


$percent = 0.10

$input_dir  = "~/code/work/seedlings/datavyu_scripts/data/chichecks_orig_chiextracted"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chichecks_recode_10"
$original_out = "~/code/work/seedlings/datavyu_scripts/data/chichecks_orig_10"


def recode(in_dir, file)
  puts(file)
  $db, $pj = load_db(File.join(in_dir, file))
  col = get_column("child_labeled_object")
  columns = get_column_list()

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
  puts("numcells: #{annotation_cells.size}  randrange: #{randrange}  n: #{n}   start: #{start}   end: #{start+n} ")

  recode_slice = annotation_cells[start..start+(n-1)]

  new_column = create_new_column("recode_pho", "object",
                                 "utterance_type","object_present",
                                 "speaker", "original_ordinal")
  for cell in recode_slice
    parent = col.cells[cell.ordinal-2]
    parent_chi = new_column.make_new_cell()
    parent_chi.change_code("object", parent.object)
    parent_chi.change_code("utterance_type", "NA")
    parent_chi.change_code("object_present", "NA")
    parent_chi.change_code("speaker", parent.speaker)
    parent_chi.change_code("onset", parent.onset)
    parent_chi.change_code("offset", parent.offset)
    parent_chi.change_code("original_ordinal", parent.original_ordinal)

    newcell = new_column.make_new_cell()
    newcell.change_code("object", "%pho: ")
    newcell.change_code("onset", cell.onset)
    newcell.change_code("offset", cell.offset)

    newcell.change_code("utterance_type", "NA")
    newcell.change_code("speaker", "NA")
    newcell.change_code("object_present", "NA")
    newcell.change_code("original_ordinal", "NA")

  end

  for colu in columns
    delete_variable(colu)
  end
  set_column(new_column)
  save_db(File.join(File.expand_path($output_dir), file.sub(".opf", "_recode.opf")))
  delete_variable(new_column)

  # output the original annotations to a separate opf
  new_column = create_new_column("recode_pho", "object",
                                 "utterance_type","object_present",
                                 "speaker", "original_ordinal")

 for cell in recode_slice
   parent = col.cells[cell.ordinal-2]
   parent_chi = new_column.make_new_cell()
   parent_chi.change_code("object", parent.object)
   parent_chi.change_code("utterance_type", parent.utterance_type)
   parent_chi.change_code("object_present", parent.object_present)
   parent_chi.change_code("speaker", parent.speaker)
   parent_chi.change_code("onset", parent.onset)
   parent_chi.change_code("offset", parent.offset)
   parent_chi.change_code("original_ordinal", parent.original_ordinal)

   newcell = new_column.make_new_cell()
   newcell.change_code("object", cell.object)
   newcell.change_code("onset", cell.onset)
   newcell.change_code("offset", cell.offset)
   newcell.change_code("utterance_type", cell.utterance_type)
   newcell.change_code("speaker", cell.speaker)
   newcell.change_code("object_present", cell.object_present)
   newcell.change_code("original_ordinal", cell.original_ordinal)
 end

 set_column(new_column)
 save_db(File.join(File.expand_path($original_out), file.sub(".opf", "_recode_orig.opf")))

  # end
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
