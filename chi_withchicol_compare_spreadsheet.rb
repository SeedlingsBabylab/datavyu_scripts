require 'Datavyu_API'

$origin_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/full_with_chi_col"
$merged_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/merged_full_with_chi_col"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chimerge/output"

$csv_out_path = File.expand_path("~/code/work/seedlings/datavyu_scripts/data/chimerge_orig_vs_new.csv")

def merge(orig_in, reco_in, groups)
    CSV.open($csv_out_path, "wb") do |csv|
        csv << ["file", "orig", "recode", "T_F"]
    end
    groups.each_value { |files|
      prefix = files["orig"][0..4]
      puts("**********#{prefix}*********")
  
      if files["merged"].nil?
        next
      end
  
      $db, $pj = load_db(File.join(reco_in, files["merged"]))
      merged_col = get_column("child_labeled_object")
  
      $db, $pj = load_db(File.join(orig_in, files["orig"]))
      
      orig_col = get_column("child_labeled_object")
      


    #   orig_chis = orig_column.cells.select {|cell| cell.speaker == "CHI"}
    #   new_chis = conv_col.cells.select { |cell| !cell.object.start_with? "%pho"}

      CSV.open($csv_out_path, "a") do |csv|
        for orig_cell in orig_col.cells
            # puts(cell.original_ordinal)
            found = false

            if orig_cell.object.to_s.start_with?("%pho:") #lookup pho's by timestamp
                for merged_cell in merged_col.cells
                    if merged_cell.onset.to_s == orig_cell.onset.to_s && merged_cell.offset.to_s == orig_cell.offset.to_s && merged_cell.object.to_s.start_with?("%pho:")
                        # puts("found ordinal: #{c.ordinal}")
                        merg_cell = merged_cell
                        found = true
                    end
                end
            else
                for merged_cell in merged_col.cells # lookup chi's by "original_ordinal"
                    if merged_cell.original_ordinal.to_s == orig_cell.original_ordinal.to_s
                        # puts("found ordinal: #{c.ordinal}")
                        merg_cell = merged_cell
                        found = true
                    end
                end

            end
        if !found
            merg_cell = orig_column.make_new_cell()
            merg_cell.change_code("object", "XXXX")
            merg_cell.change_code("utterance_type", "XXX")
            merg_cell.change_code("object_present", "XXX")
            merg_cell.change_code("speaker", "XXX")
            puts("new not found")
          end
            # puts(orig_cell.object)
            orig = "#{orig_cell.object}_#{orig_cell.utterance_type}_#{orig_cell.object_present}_#{orig_cell.speaker}_#{orig_cell.onset}_#{orig_cell.offset}_#{orig_cell.original_ordinal}"
            merg = "#{merg_cell.object}_#{merg_cell.utterance_type}_#{merg_cell.object_present}_#{merg_cell.speaker}_#{merg_cell.onset}_#{merg_cell.offset}_#{merg_cell.original_ordinal}"
            # if orig_cell.object.start_with? "%pho"
            #     orig = ""
            # end
            csv << [prefix, orig, merg, ""]

        end
      end
    }
  end


begin
    orig_in = File.expand_path($origin_in)
    merg_in = File.expand_path($merged_in)
  
    orig_files = Dir.new(orig_in).entries
    merg_files = Dir.new(merg_in).entries
  
    filenames = orig_files + merg_files
  
    groups = Hash.new
    for file in filenames
      if file.end_with? ".opf"
        prefix = file[0..4]
        if groups.has_key?(prefix)
          if file.include? "_merged.opf"
            groups[prefix]["merged"] = file
          else
            groups[prefix]["orig"] = file
          end
        else
          groups[prefix] = Hash.new
          if file.include? "_merged.opf"
            groups[prefix]["merged"] = file
          else
            groups[prefix]["orig"] = file
          end
        end
      end
    end
    # puts(groups)
    merge(orig_in, merg_in, groups)
  
  
  end
  