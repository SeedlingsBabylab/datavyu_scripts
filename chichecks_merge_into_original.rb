require 'Datavyu_API'


$merge_table = "~/code/work/seedlings/datavyu_scripts/data/chimerge/chimerge_orig_vs_new.csv"
$original_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/original"

def filter_table(table, file)
    return table.select{|row| row[0] == file}
end

def old_new_match(old, merg)
    if merg[0].start_with?("pho")
        if old.onset.to_s == merg[4] and old.offset.to_s == merg[5]
            return true
        else
            return false
        end
    end
    if old.ordinal.to_s == merg[6]
        return true
    else
        return false
    end
end

def merge(table, files)
    for file in files
        if file.end_with?(".opf")
            puts(file)
            $db, $pj = load_db(File.join(File.expand_path($original_in), file))
            f_prefix = file[0..4]
            entries = filter_table(table, f_prefix)
            cols = get_column_list()
            if cols.length != 1
                puts("\n#{files["orig"]} has more than 1 column\n\n")
                exit
            else
                col = cols[0]
                orig_column = get_column(col)
            end

            new_column = create_new_column("labeled_object_new", "object", "utterance_type", "object_present", "speaker", "original_ordinal")

            for orig_cell in orig_column.cells
                found = false
                for code in entries
                    # puts(code)
                    # puts(code.length)
                    # puts(code[1])
                    # puts(code[2].split("_"))
                    orig_code = code[1].split("_")
                    merg_code = code[2].split("_")
                    if old_new_match(orig_cell, merg_code)
                        found = true
                        puts("hurray")
                    end
                end

                if !found
                    merg_cell = orig_column.make_new_cell()
                    merg_cell.change_code("object", cell)
                    merg_cell.change_code("utterance_type", "XXX")
                    merg_cell.change_code("object_present", "XXX")
                    merg_cell.change_code("speaker", "XXX")
                    puts("new not found")
                end

                    
            end
        end


    end
end


begin 

    merge_table_in = File.expand_path($merge_table)
    merge_table = CSV.read(merge_table_in)

    original_files = Dir.new(File.expand_path($original_in)).entries
    merge(merge_table, original_files)
end