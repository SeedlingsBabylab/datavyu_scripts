require 'Datavyu_API'


$input_dir = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/orig_out_cprod" # can also be orig_out_attobj, doesnt matter
$output_dir = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/orig_out_with_preceding15"


def add_15_region(in_dir, file)
  $db, $pj = load_db(File.join(in_dir, file))
  columns = get_column_list()
  clm = nil
  puts(file)
  for col in columns
    if col.include?("recode_") || col.include?("original_")
      clm = col
      break
    end
  end

  col = get_column(clm)
  out_path = File.join(File.expand_path($output_dir), file.sub(".opf", "_preceding_15s.opf"))

  new_col = create_new_column("preceding_15_seconds", "transcript", "speaker" , "orig_ordinal")

  for cell in col.cells
    if cell.onset > 15000
      new_cell = new_col.make_new_cell()
      new_cell.onset = cell.onset - 15000
      new_cell.offset = cell.onset
      new_cell.change_code("orig_ordinal", cell.orig_ordinal)
    else
      new_cell = new_col.make_new_cell()
      new_cell.onset = 0
      new_cell.offset = cell.onset
      new_cell.change_code("orig_ordinal", cell.orig_ordinal)
    end
  end

  set_column(new_col)
  delete_variable(col)
  save_db(out_path)
end


begin

  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with?(".opf")
      add_15_region(in_dir, file)
    end
  end

end
