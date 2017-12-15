require 'Datavyu_API'

# $input_dir = "~/code/work/seedlings/pho_reliability_opf/pass2/recode"
# $output_dir = "~/code/work/seedlings/pho_reliability_opf/pass2/orig_and_recode_csv"

# $input_dir = "~/code/work/seedlings/batch_opf_bl/17_chi_merged"
# $output_dir = "~/code/work/seedlings/batch_opf_bl/output"

# $input_dir = "~/code/work/seedlings/reliability_data/by_month/07/orig_rel_10"
# $output_dir = "~/code/work/seedlings/reliability_data/by_month/07/csv_out"

# $input_dir = "~/code/work/seedlings/datavyu_scripts/data/chi_checks2_3"
# $output_dir = "~/code/work/seedlings/datavyu_scripts/data/batch_bl_out"

# $input_dir = "~/code/work/seedlings/datavyu_scripts/data/reliability_checks/07/orig_rel_10"
# $output_dir = "~/code/work/seedlings/datavyu_scripts/data/reliability_checks/07/csv_out"

$input_dir = "~/code/work/seedlings/datavyu_scripts/data/chi_cv_checks/recode_out"
$output_dir = "~/code/work/seedlings/datavyu_scripts/data/chi_cv_checks/csv_out"

# $input_dir = "~/code/work/seedlings/collect/06_opf"
# $output_dir = "~/code/work/seedlings/collect/06_video_csvs"


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
      csv << ["onset", "offset","type","ctype",
              "voctype","notes", "object","cgprompt",
              "cgresponse", "orig_ordinal"]
      for cell in col.cells
        # puts cell.ordinal.to_s
        # puts cell.object.to_s
        # puts "\n\n"
        if !cell.object.to_s.start_with?("%pho")
          csv << [cell.onset.to_s, cell.offset.to_s, cell.type.to_s, cell.ctype.to_s,
                  cell.voctype.to_s, cell.notes.to_s, cell.object.to_s, cell.cgprompt.to_s,
                  cell.cgresponse.to_s, cell.orig_ordinal.to_s]
        end
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
