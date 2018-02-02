require 'Datavyu_API'

$original = "~/code/work/seedlings/datavyu_scripts/data/blind/compare/03_12_coderGC_final.opf"
$new = "~/code/work/seedlings/datavyu_scripts/data/blind/compare/03_12_CR_blind.opf"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/blind/compare/output"

def compare(orig_file, new_file)
    prefix = File.basename(orig_file)[0..4]

    # get original file
    $db, $pj = load_db(orig_file)
    columns = get_column_list()
    if columns.length != 1
        puts "more than 1 column in #{orig_file}"
        exit
    end
    orig_col = getColumn(columns[0])

    # get new file
    $db, $pj = load_db(new_file)
    columns = get_column_list()
    if columns.length != 1
        puts "more than 1 column in #{orig_file}"
        exit
    end
    new_col = getColumn(columns[0])

    if new_col.cells.length != orig_col.cells.length
        "mismatch between # fo cells in the original vs. new file"
        exit
    end

    joined = orig_col.cells.zip(new_col.cells)

    csv_out_path = File.join(File.expand_path($output_dir), 
                            "#{prefix}_blind_compare.csv")

    CSV.open(csv_out_path, "wb") do |csv|
        csv << ["orig.ordinal","orig.onset",
                "orig.offset","orig.object",
                "orig.utterance_type","orig.object_present",
                "orig.speaker","orig.basic_level",
                "new.ordinal","new.onset",
                "new.offset","new.object",
                "new.utterance_type","new.object_present",
                "new.speaker","new.basic_level"]
        for cell in joined
          if !cell[0].object.to_s.start_with?("%pho") && !cell[0].object.to_s.start_with?("%com")
            csv << [cell[0].ordinal.to_s, cell[0].onset.to_s, cell[0].offset.to_s, 
                    cell[0].object.to_s, cell[0].utterance_type.to_s, cell[0].object_present.to_s, 
                    cell[0].speaker.to_s, "",
                    cell[1].ordinal.to_s, cell[1].onset.to_s, cell[1].offset.to_s, 
                    cell[1].object.to_s, cell[1].utterance_type.to_s, cell[1].object_present.to_s, 
                    cell[1].speaker.to_s, ""]
          end
        end
    end
end



begin
    orig_file = File.expand_path($original)
    new_file = File.expand_path($new)
    compare(orig_file, new_file)
end