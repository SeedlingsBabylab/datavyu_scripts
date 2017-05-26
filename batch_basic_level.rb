require 'Datavyu_API'

$input_dir = "~/code/work/seedlings/reliability_data/batch_recode_out"
$output_dir = "~/code/work/seedlings/batch_opf_bl"


def basic_level(in_dir, file)
  puts(file)
  $db, $pj = load_db(File.join(in_dir, file))
  columns = get_column_list()
  for column in columns
    bl_out_path = File.join(File.expand_path($output_dir), file.sub(".opf", "_processed.csv"))
    col = getColumn(column)
    if col.cells.length == 0
      next
    end


    CSV.open(bl_out_path, "wb") do |csv|
      csv << ["labeled_object.ordinal","labeled_object.onset",
              "labeled_object.offset","labeled_object.object",
              "labeled_object.utterance_type","labeled_object.object_present",
              "labeled_object.speaker","basic_level"]
      for cell in col.cells
        csv << [cell.ordinal.to_s, cell.onset.to_s, cell.offset.to_s, cell.object.to_s,
                cell.utterance_type.to_s, cell.object_present.to_s, cell.speaker.to_s, ""]
      end
    end


  end
end




begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with? ".opf"
      basic_level(in_dir, file)
    end
  end
end
