require 'Datavyu_API'

# $origin_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/original"
# $recode_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/chichecked"
# $output_dir = "~/code/work/seedlings/datavyu_scripts/data/chimerge/output"

$origin_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/original"
$recode_in = "~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/chichecked_final"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/output"

# $csv_out_path = File.expand_path("~/code/work/seedlings/datavyu_scripts/data/chimerge_orig_vs_new.csv")
$csv_out_path = File.expand_path("~/code/work/seedlings/datavyu_scripts/data/chimerge/problems/chimerge_orig_vs_new.csv")

def merge(orig_in, reco_in, groups)
    CSV.open($csv_out_path, "wb") do |csv|
        csv << ["file", "orig", "recode", "T_F"]
    end
    groups.each_value { |files|
      prefix = files["orig"][0..4]
      puts("**********#{prefix}*********")
  
      if files["consensus"].nil?
        next
      end
  
      $db, $pj = load_db(File.join(reco_in, files["consensus"]))
      conv_col = get_column("recode")
  
      $db, $pj = load_db(File.join(orig_in, files["orig"]))
  
      cols = get_column_list()
  
      if cols.length != 1
        puts("\n#{files["orig"]} has more than 1 column\n\n")
        exit
      else
        col = cols[0]
        orig_column = get_column(col)
      end

      orig_chis = orig_column.cells.select {|cell| cell.speaker == "CHI"}
      new_chis = conv_col.cells.select { |cell| !cell.object.start_with? "%pho"}

      CSV.open($csv_out_path, "a") do |csv|
        for orig_cell in orig_chis
            # puts(cell.original_ordinal)
            found = false
            for c in new_chis
              if c.original_ordinal.to_s == orig_cell.ordinal.to_s
              #   puts("found ordinal: #{c.ordinal}")
                reco_cell = c
                found = true
              end
            end
        if !found
            reco_cell = orig_column.make_new_cell()
            reco_cell.change_code("object", "XXXX")
            reco_cell.change_code("utterance_type", "XXX")
            reco_cell.change_code("object_present", "XXX")
            reco_cell.change_code("speaker", "XXX")
            puts("new not found")
          end
            # puts(orig_cell.object)
            orig = "#{orig_cell.object}_#{orig_cell.utterance_type}_#{orig_cell.object_present}_#{orig_cell.speaker}_#{orig_cell.onset}_#{orig_cell.offset}"
            reco = "#{reco_cell.object}_#{reco_cell.utterance_type}_#{reco_cell.object_present}_#{reco_cell.speaker}_#{reco_cell.onset}_#{reco_cell.offset}"
            if orig_cell.object.start_with? "%pho"
                orig = ""
            end
            csv << [prefix, orig, reco, ""]

        end
      end


    #   CSV.open($csv_out_path, "a") do |csv|
    #     for cell in conv_col.cells
    #         # puts(cell.original_ordinal)
    #         found = false
    #         for c in orig_column.cells
    #           if c.ordinal.to_s == cell.original_ordinal.to_s
    #           #   puts("found ordinal: #{c.ordinal}")
    #             orig_cell = c
    #             found = true
    #           end
    #         end
    #     if !found
    #         orig_cell = orig_column.make_new_cell()
    #         orig_cell.change_code("object", "**NEW**")
    #         orig_cell.change_code("utterance_type", "XXX")
    #         orig_cell.change_code("object_present", "XXX")
    #         orig_cell.change_code("speaker", "XXX")
    #         puts("made a new cell")
    #       end
    #         # puts(orig_cell.object)
    #         orig = "#{orig_cell.object}_#{orig_cell.utterance_type}_#{orig_cell.object_present}_#{orig_cell.speaker}_#{orig_cell.onset}_#{orig_cell.offset}"
    #         reco = "#{cell.object}_#{cell.utterance_type}_#{cell.object_present}_#{cell.speaker}_#{cell.onset}_#{cell.offset}"
    #         if cell.object.start_with? "%pho"
    #             orig = ""
    #         end
    #         csv << [prefix, orig, reco, ""]

    #     end
    #   end
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
  