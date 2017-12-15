require 'Datavyu_API'


$percent = 0.10

$input_dir  = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv2/input_orig"
$output_dir = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv2/recode_out"
$original_out = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv2/orig_out"


def recode(in_dir, file)
  puts(file)
  $db, $pj = load_db(File.join(in_dir, file))

  vocalization_col = "Infant_vocalization"
  col = get_column(vocalization_col)

  annotation_cells = col.cells.select do |elem|
    elem.type.to_s.start_with? "C"
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
  puts("full size: #{col.cells.size}  annot_cells: #{annotation_cells.size}  randrange: #{randrange}  n: #{n}   start: #{start}   end: #{start+n} ")

  recode_slice = annotation_cells[start..start+(n-1)]

  new_column = create_new_column("recode_vocalization", "type", "ctype", "voctype","notes", "object", "cgprompt", "cgresponse", "orig_ordinal")
  for cell in recode_slice
    newcell = new_column.make_new_cell()
    newcell.change_code("type", cell.type)
    newcell.change_code("onset", cell.onset)
    newcell.change_code("offset", cell.offset)

    newcell.change_code("ctype", "NA")
    newcell.change_code("voctype", "NA")
    newcell.change_code("notes", "NA")
    newcell.change_code("object", "NA")
    newcell.change_code("cgprompt", "NA")
    newcell.change_code("cgresponse", "NA")
    newcell.change_code("orig_ordinal", cell.ordinal)
  end

  columns = get_column_list()

  for colu in columns
    delete_variable(colu)
  end
  set_column(new_column)
  save_db(File.join(File.expand_path($output_dir), file.sub(".opf", "_recode.opf")))
  delete_variable(new_column)

  # output the original annotations to a separate opf
  new_column = create_new_column("original_vocalization", "type", "ctype", "voctype","notes", "object", "cgprompt", "cgresponse", "orig_ordinal")

 for cell in recode_slice

   newcell = new_column.make_new_cell()
   newcell.change_code("type", cell.type)
   newcell.change_code("ctype", cell.ctype)
   newcell.change_code("voctype", cell.voctype)
   newcell.change_code("notes", cell.notes)
   newcell.change_code("object", cell.object)
   newcell.change_code("cgprompt", cell.cgprompt)
   newcell.change_code("cgresponse", cell.cgresponse)

   newcell.change_code("orig_ordinal", cell.ordinal)


   newcell.change_code("onset", cell.onset)
   newcell.change_code("offset", cell.offset)

 end

 set_column(new_column)
 save_db(File.join(File.expand_path($original_out), file.sub(".opf", "_recode_orig.opf")))


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
