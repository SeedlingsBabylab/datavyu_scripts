require 'Datavyu_API.rb'


$input_dir = "~/code/work/seedlings/datavyu_scripts/data/chichecks_orig"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chichecks_orig_chiextracted"


def getchild(in_dir, file)
	puts(file)
  $db, $pj = load_db(File.join(in_dir, file))
	columns = get_column_list()
	column = columns[0]
	puts column
	col = get_column(column)
	child_column = create_new_column("child_labeled_object", "object","utterance_type","object_present","speaker", "original_ordinal")
	for cell in col.cells
		if (cell.speaker.to_s == 'CHI') or (cell.object.to_s.start_with?("%com: mwu")) or (cell.object.to_s.start_with?("%com: first word"))
			newcell = child_column.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", cell.utterance_type)
			newcell.change_code("object_present", cell.object_present)
			newcell.change_code("speaker", cell.speaker)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
			newcell.change_code("original_ordinal", cell.ordinal)

			phocell = child_column.make_new_cell()
			phocell.change_code("object", "%pho:")
			phocell.change_code("utterance_type", "NA")
			phocell.change_code("object_present", "NA")
			phocell.change_code("speaker", "NA")
			phocell.change_code("onset", cell.offset)
			phocell.change_code("offset", cell.offset)
			phocell.change_code("ordinal", cell.ordinal)
			phocell.change_code("original_ordinal", "NEW")
		end
	end
	set_column(child_column)
  save_db(File.join(File.expand_path($output_dir), file.sub(".opf", "_recode.opf")))
end


begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with? ".opf"
			puts file
      getchild(in_dir, file)
    end
  end
end
