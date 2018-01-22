require 'Datavyu_API'

$input_dir = "~/code/work/seedlings/datavyu_scripts/data/blind/input"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/blind/output"

def blind(in_dir, file)
    puts(file)
    prefix = file[0..4]
    $db, $pj = load_db(File.join(in_dir, file))
    columns = get_column_list()
    for column in columns
        bl_out_path = File.join(File.expand_path($output_dir), file.sub(".opf", "_processed.csv"))
        col = getColumn(column)
        if col.cells.length == 0
            next
        end
    
        for cell in col.cells
            if !cell.object.to_s.start_with?("%")
                cell.change_code("object", "NA")
                cell.change_code("utterance_type", "NA")
                cell.change_code("object_present", "NA")
                cell.change_code("speaker", "NA")
            end

        end
        
        set_column(col)
        save_db(File.join(File.expand_path($output_dir), "#{prefix}_blind.opf"))
    end
end


begin
    in_dir = File.expand_path($input_dir)
    filenames = Dir.new(in_dir).entries
  
    for file in filenames
      if file.end_with? ".opf"
        blind(in_dir, file)
      end
    end
  end
  
