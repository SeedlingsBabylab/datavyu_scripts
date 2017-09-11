require 'Datavyu_API'

$input_dir = "~/code/work/seedlings/datavyu_scripts/data/chichecks_recode_merge"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chichecks_finalout"



def merge(in_dir, groups)
  groups.each_value { |files|
    prefix = files["orig"][0..4]
    puts("**********#{prefix}*********")

    if files["consensus"].nil?
      next
    end

    $db, $pj = load_db(File.join(in_dir, files["consensus"]))
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
      # puts(cell.original_ordinal)
      found = false
      for c in orig_column.cells
        if c.ordinal.to_s == cell.original_ordinal.to_s
          puts("found ordinal: #{c.ordinal}")
          orig_cell = c
          found = true
        end
      end
      # orig_cell = orig_column.cells[cell.original_ordinal.to_i-1]
      if !found
        orig_cell = orig_column.make_new_cell()
        puts("made a new cell")
      end
        puts(orig_cell.object)
        orig_cell.change_code("object", cell.object)
        orig_cell.change_code("utterance_type", cell.utterance_type)
        orig_cell.change_code("object_present", cell.object_present)
        orig_cell.change_code("speaker", cell.speaker)
        orig_cell.change_code("onset", cell.onset)
        orig_cell.change_code("offset", cell.offset)
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
        if file.include? "consensus_relia.opf"
          groups[prefix]["consensus"] = file
        else
          groups[prefix]["orig"] = file
        end
      else
        groups[prefix] = Hash.new
        if file.include? "consensus_relia.opf"
          groups[prefix]["consensus"] = file
        else
          groups[prefix]["orig"] = file
        end
      end
    end
  end
  # puts(groups)
  merge(in_dir, groups)

end
