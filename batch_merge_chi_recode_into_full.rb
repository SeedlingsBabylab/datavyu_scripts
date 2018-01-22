require 'Datavyu_API'

# $origin_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/full_with_chi_col"
# $recode_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/consensus"
# $output_dir = "~/code/work/seedlings/datavyu_scripts/data/chimerge/output"

$origin_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/full_with_chi_col"
$recode_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/consensus"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/output"


def merge(orig_in, reco_in, groups)
  groups.each_value { |files|
    prefix = files["orig"][0..4]
    puts("**********#{prefix}*********")

    if files["consensus"].nil?
      next
    end

    $db, $pj = load_db(File.join(reco_in, files["consensus"]))
    conv_col = get_column("recode")

    $db, $pj = load_db(File.join(orig_in, files["orig"]))

    orig_column = get_column("child_labeled_object")

    last_chi_ordinal = 0

    for cell in conv_col.cells
        found = false
        if cell.object.to_s.start_with?("%pho:") #lookup pho's by timestamp
            for c in orig_column.cells
                if c.onset.to_s == cell.onset.to_s && c.offset.to_s == cell.offset.to_s && c.object.to_s.start_with?("%pho:")
                    # puts("found ordinal: #{c.ordinal}")
                    orig_cell = c
                    found = true
                end
            end
        else
            for c in orig_column.cells # lookup chi's by "original_ordinal"
                if c.original_ordinal.to_s == cell.original_ordinal.to_s
                    # puts("found ordinal: #{c.ordinal}")
                    orig_cell = c
                    found = true
                end
            end

        end

        # orig_cell = orig_column.cells[cell.original_ordinal.to_i-1]
        if !found
            orig_cell = orig_column.make_new_cell()
            puts("XXXXXXXXXXXX made a new cell XXXXXXXXXXXXX")
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

    save_db(File.join(File.expand_path($output_dir), File.basename(files["orig"]).gsub(".opf", "_merged.opf")))
  }
end



begin

  orig_in = File.expand_path($origin_in)
  reco_in = File.expand_path($recode_in)

  orig_files = Dir.new(orig_in).entries
  reco_files = Dir.new(reco_in).entries

  filenames = orig_files + reco_files

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
  merge(orig_in, reco_in, groups)

end
