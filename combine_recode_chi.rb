require 'Datavyu_API'


$orig_input = "~/code/work/seedlings/datavyu_scripts/data/chi_checks/11/orig_10_percent"
$recode_input = "~/code/work/seedlings/datavyu_scripts/data/chi_checks/11/reliability_checks"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chi_checks/11/converge_out"





def cells_equal(cell1, cell2)
  if cell1.get_codes() == cell2.get_codes() &&
    cell1.ordinal == cell2.ordinal &&
    cell1.onset == cell2.onset && cell1.offset == cell2.offset
    return true
  else
    return false
  end
end



def combine(orig_dir, reco_dir, groups)

  groups.each_value { |files|

    prefix = files["orig"][0..4]
    puts("*****************#{prefix}*********")

    $db, $pj = load_db(File.join(reco_dir, files["recode"]))
    recode_col = get_column("recode_pho")

    $db, $pj = load_db(File.join(orig_dir, files["orig"]))
    orig_col = get_column("recode_pho")

    new_orig_col = create_new_column("original", "object", "utterance_type","object_present","speaker", "original_ordinal")
    new_recode_col = create_new_column("recode", "object", "utterance_type","object_present","speaker", "original_ordinal", "match")
    for cell in orig_col.cells
      found_match = false

      for reco_cell in recode_col.cells
        # puts("#{cell.get_codes()}\n#{reco_cell.get_codes()}\n\n")
        if cells_equal(cell, reco_cell)
          # puts("#{cell.get_codes()}\n#{reco_cell.get_codes()}\n\n")
          # puts("found a match\n\n")
          found_match = true
          break
        end
      end

      # if !found_match
      newcell = new_orig_col.make_new_cell()
			newcell.change_code("object", cell.object)
			newcell.change_code("utterance_type", cell.utterance_type)
			newcell.change_code("object_present", cell.object_present)
			newcell.change_code("speaker", cell.speaker)
			newcell.change_code("onset", cell.onset)
			newcell.change_code("offset", cell.offset)
			newcell.change_code("ordinal", cell.ordinal)
      newcell.change_code("original_ordinal", cell.original_ordinal)

      not_matched = recode_col.cells[cell.ordinal-1]
      newrecode = new_recode_col.make_new_cell()
			newrecode.change_code("object", not_matched.object)
			newrecode.change_code("utterance_type", not_matched.utterance_type)
			newrecode.change_code("object_present", not_matched.object_present)
			newrecode.change_code("speaker", not_matched.speaker)
			newrecode.change_code("onset", not_matched.onset)
			newrecode.change_code("offset", not_matched.offset)
			newrecode.change_code("ordinal", not_matched.ordinal)
      newrecode.change_code("original_ordinal", not_matched.original_ordinal)
      if !found_match
        newrecode.change_code("match", "MISMATCH")
      else
        newrecode.change_code("match", "MATCH")
      end
    end

    delete_variable(orig_col)
    set_column(new_orig_col)
    set_column(new_recode_col)

    if (new_recode_col.cells.size != 0)
      save_db(File.join(File.expand_path($output_dir), "#{prefix}_consensus_relia.opf"))
    end
  }

end


begin
  orig_in = File.expand_path($orig_input)
  reco_in = File.expand_path($recode_input)

  orig_files = Dir.new(orig_in).entries
  reco_files = Dir.new(reco_in).entries

  filenames = orig_files + reco_files

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
  combine(orig_in, reco_in, groups)

end
