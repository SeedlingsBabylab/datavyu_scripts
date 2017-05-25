require 'Datavyu_API'


$input_dir = "~/code/work/seedlings/recode_converge_opfs"
$output_dir = "~/code/work/seedlings/converge_opfs"



def combine(in_dir, groups)

  groups.each_value { |files|

    $db, $pj = load_db(File.join(in_dir, files["recode"]))
    recode_col = get_column("recode")

    $db, $pj = load_db(File.join(in_dir, files["orig"]))
    orig_col = get_column("recode")
    orig_col.name = "original"
    set_column(orig_col)

    new_column = create_new_column("recode", "object", "utterance_type","object_present","speaker")
    for cell in recode_col.cells
      newcell = new_column.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", cell.utterance_type)
			newcell.change_code("object_present", cell.object_present)
			newcell.change_code("speaker", cell.speaker)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
    end
    set_column(new_column)
    prefix = files["orig"][0..4]
    puts(prefix)
    save_db(File.join(File.expand_path($output_dir), "#{prefix}_converge_rel.opf"))
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
        if file.include? "_orig"
          groups[prefix]["orig"] = file
        else
          groups[prefix]["recode"] = file
        end
      else
        groups[prefix] = Hash.new
        if file.include? "_orig"
          groups[prefix]["orig"] = file
        else
          groups[prefix]["recode"] = file
        end
      end
    end
  end
  puts(groups)
  combine(in_dir, groups)

end
