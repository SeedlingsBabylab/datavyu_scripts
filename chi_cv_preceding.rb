require 'Datavyu_API'


$input_dir = "~/code/work/seedlings/datavyu_scripts/data/chi_cv_checks/orig_out"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chi_cv_checks/orig_out_with_preceding15"


def add_15_region(in_dir, file)
  $db, $pj = load_db(File.join(in_dir, file))
  columns = get_column_list()
  clm = nil
  puts(file)
  for col in columns
    if col.include?("_vocalization")
      clm = col
      break
    end
  end

  col = get_column(clm)
  out_path = File.join(File.expand_path($output_dir), file.sub(".opf", "_processed.opf"))

  new_col = create_new_column("preceding_15_seconds", "type",
                              "ctype", "voctype","notes", "object",
                              "cgprompt", "cgresponse", "orig_ordinal")

  for cell in col.cells
    if cell.onset > 15000
      new_cell = new_col.make_new_cell()
      new_cell.onset = cell.onset - 15000
      new_cell.offset = cell.onset
    else
      new_cell = new_col.make_new_cell()
      new_cell.onset = 0
      new_cell.offset = cell.onset
    end
  end

  set_column(new_col)
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
