require 'Datavyu_API'


$input_dir = "~/code/work/bergelsonlab/pho_checks_in_2"





def rewrite_times(in_dir, file)
  puts(file)
  $db, $pj = load_db(File.join(in_dir, file))

  col = get_column("child_labeled_object")
  col.cells.each_with_index do |cell, i|
    if cell.object.to_s.start_with? "%pho"
      parent = col.cells[i-1]
      cell.onset = parent.onset
      cell.offset = parent.offset
    end

  set_column(col)
  save_db(File.join(in_dir, file))

  end
end



begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with? ".opf"
      rewrite_times(in_dir, file)
    end
  end
end
