require 'Datavyu_API'

$input_dir = "~/code/work/seedlings/reliability_data/recode_merging"
$output_dir = "~/code/work/seedlings/reliability_data/final_out"


def merge(in_dir, groups)
  groups.each_value { |files|
    prefix = files["orig"][0..4]
    puts("**********#{prefix}*********")

    $db, $pj = load_db(File.join(in_dir, files["converge"]))
    conv_col = get_column("recode")

    $db, $pj = load_db(File.join(in_dir, files["orig"]))

    cols = get_column_list()

    if cols.length != 1
      puts("\n#{files["orig"]} has more than 1 column\n\n")
      exit
    else
      col = cols[0]
      orig_column = get_column(col)
    end

    for cell in conv_col.cells
      puts(cell.original_ordinal)
      orig_column.cells[cell.original_ordinal.to_i-1]
    end

    set_column(orig_column)

    save_db(File.join(File.expand_path($output_dir), File.basename(files["orig"])))
  }
end



begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  groups = Hash.new
  for file in filenames
    if file.end_with? ".opf"
      prefix = file[0..4]
      if groups.has_key?(prefix)
        if file.include? "converge_rel.opf"
          groups[prefix]["converge"] = file
        else
          groups[prefix]["orig"] = file
        end
      else
        groups[prefix] = Hash.new
        if file.include? "converge_rel.opf"
          groups[prefix]["converge"] = file
        else
          groups[prefix]["orig"] = file
        end
      end
    end
  end
  puts(groups)
  merge(in_dir, groups)

end
