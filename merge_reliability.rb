require 'Datavyu_API'

$origin_in = "/Volumes/pn-opus/Seedlings/Working_Files/reliability_12/video/full_files"
$recode_in = "/Volumes/pn-opus/Seedlings/Working_Files/reliability_12/video/converge_out"
$output_dir = "/Volumes/pn-opus/Seedlings/Working_Files/reliability_12/video/final_out"



def merge(orig_in, reco_in, groups)
  groups.each_value { |files|
    prefix = files["orig"][0..4]
    puts("**********#{prefix}*********")
    puts files
    if files["consensus"].nil?
      puts "no consensus"
      next
    end

    $db, $pj = load_db(File.join(reco_in, files["consensus"]))
    conv_col = get_column("recode")

    $db, $pj = load_db(File.join(orig_in, files["orig"]))

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
        #   puts("found ordinal: #{c.ordinal}")
          orig_cell = c
          found = true
        end
      end
      # orig_cell = orig_column.cells[cell.original_ordinal.to_i-1]
      if !found
        orig_cell = orig_column.make_new_cell()
        puts("made a new cell")
      end
        # puts(orig_cell.object)
        orig_cell.change_code("object", cell.object)
        orig_cell.change_code("utterance_type", cell.utterance_type)
        orig_cell.change_code("object_present", cell.object_present)
        orig_cell.change_code("speaker", cell.speaker)
        orig_cell.change_code("id", cell.id)
        orig_cell.change_code("onset", cell.onset)
        orig_cell.change_code("offset", cell.offset)
    end

    set_column(orig_column)
    puts "saving"
    save_db(File.join(File.expand_path($output_dir), File.basename(files["orig"])))
  }
end



begin

  orig_in = File.expand_path($origin_in)
  reco_in = File.expand_path($recode_in)

  orig_files = Dir.new(orig_in).entries
  reco_files = Dir.new(reco_in).entries

  filenames = orig_files + reco_files
  # puts orig_files
  # puts reco_files

  groups = Hash.new
  for file in filenames
    if file.end_with? ".opf"
      prefix = file[0..4]
      if groups.has_key?(prefix)
        if file.include? "converge_rel.opf"
          groups[prefix]["consensus"] = file
        else
          groups[prefix]["orig"] = file
        end
      else
        groups[prefix] = Hash.new
        if file.include? "converge_rel.opf"
          groups[prefix]["consensus"] = file
        else
          groups[prefix]["orig"] = file
        end
      end
    end
  end
  puts(groups)
  merge(orig_in, reco_in, groups)

end
