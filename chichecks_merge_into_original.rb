require 'Datavyu_API'


# $merge_table = "~/code/work/seedlings/datavyu_scripts/data/chimerge/chimerge_orig_vs_new_VIDEO.csv"
# $original_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/original"
# $merge_output = "~/code/work/seedlings/datavyu_scripts/data/chimerge/final_out_merged"

$merge_table = "~/code/work/seedlings/datavyu_scripts/data/chimerge/missing_16/chimerge_orig_vs_new_MONTH_16.csv"
$original_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/missing_16/original_16"
$merge_output = "~/code/work/seedlings/datavyu_scripts/data/chimerge/missing_16/final_out_merged_16"

def filter_table(table, file)
    return table.select{|row| row[0] == file}
end

def old_new_match(old, merg)
    if merg[0].start_with?("%pho")
        return (old.onset.to_s == merg[4] && 
        old.offset.to_s == merg[5] && 
        old.object.start_with?("%pho")) ?  true :  false
    end
    return old.ordinal.to_s == merg[6] ?  true :  false
end

def add_cell(col, object, utt_type, present, speaker, onset, offset)
    new_cell = col.make_new_cell()
    new_cell.change_code("object", object)
    new_cell.change_code("utterance_type", utt_type)
    new_cell.change_code("object_present", present)
    new_cell.change_code("speaker", speaker)
    new_cell.change_code("onset", onset)
    new_cell.change_code("offset", offset)
end

def change_cell(cell, merge_code)
    cell.change_code("object", merge_code[0])
    cell.change_code("utterance_type", merge_code[1])
    cell.change_code("object_present", merge_code[2])
    cell.change_code("speaker", merge_code[3])
    cell.change_code("onset", merge_code[4].to_i)
    cell.change_code("offset", merge_code[5].to_i)
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

            new_column = create_new_column("labeled_object", "object", "utterance_type", "object_present", "speaker")

            # port all the codes that already exist in the original, 
            # matching with their corresponding cell in the merge table
            matched_blank = false
            for orig_cell in orig_column.cells
                found = false
                matched_blank = false
                for code in entries
                    orig_code = code[1].split("_")
                    if !code[2] || code[2].strip() == ""
                        matched_blank = old_new_match(orig_cell, orig_code)
                        # puts "matched_blank in loop: #{matched_blank}"
                        if matched_blank
                            # if file == "16_13_coderTE_final.opf"
                            #     puts matched_blank
                            #     puts orig_cell.print_all()
                            # end
                            # puts "matched with blank cell"
                            # puts "************************"
                            # puts orig_cell.print_all()
                            # puts "----"
                            # puts orig_code
                            # puts "************************\n"
                        end
                        # next
                    end

                    if matched_blank
                        break 
                    end

                    # puts "mb: #{matched_blank}\toc: #{code[1]}\tnc: #{code[2]}"
                    if (code[2] != nil) && (code[2].strip() != "")
                        merg_code = code[2].split("_")
                        if old_new_match(orig_cell, merg_code) && (!matched_blank)
                            if file == "22_15_coderVL_final.opf"
                                puts matched_blank
                                puts puts merg_code.join(" ")
                            end
                            found = true
                            add_cell(new_column, merg_code[0], merg_code[1], 
                                    merg_code[2], merg_code[3], merg_code[4].to_i, 
                                    merg_code[5].to_i)
                        end
                    end
                end

                # puts(matched_blank)

                # if matched_blank
                #     puts(orig_cell.print_all())
                #     next
                # end


                if (!found) && (!matched_blank)
                    # if file == "16_13_coderTE_final.opf"
                    #     puts "\n"
                    #     puts matched_blank
                    #     puts orig_cell.print_all()
                    # end
                    add_cell(new_column, orig_cell.object, orig_cell.utterance_type,
                        orig_cell.object_present, orig_cell.speaker, orig_cell.onset,
                        orig_cell.offset)
                end  

            end

            # merge all the pho's
            for code in entries
                if code[2] and !(code[2].strip() == "")
                    if code[2].start_with?("%pho")
                        merg_code = code[2].split("_")
                        found = false
                        for cell in new_column.cells
                            if old_new_match(cell, merg_code) # old %pho that snuck in because timestamp matched
                                found = true
                                change_cell(cell, merg_code)
                            end
                        end
                        if !found && (!matched_blank) # new pho that needs to be added
                            # if file == "16_13_coderTE_final.opf"
                            #     puts "\n"
                            #     puts matched_blank
                            #     puts merg_code.join(" ")
                            # end
                            add_cell(new_column, merg_code[0], merg_code[1], 
                                    merg_code[2], merg_code[3], merg_code[4].to_i, 
                                    merg_code[5].to_i)
                        end
                    end
                end
            end

            for col in cols
                delete_variable(col)
            end
            set_column(new_column)
            save_db(File.join(File.expand_path($merge_output), "#{f_prefix}_sparse_code.opf"))
        end


    end
end


begin 

    merge_table_in = File.expand_path($merge_table)
    merge_table = CSV.read(merge_table_in)

    original_files = Dir.new(File.expand_path($original_in)).entries
    merge(merge_table, original_files)
end