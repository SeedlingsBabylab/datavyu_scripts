require 'Datavyu_API.rb'
require 'rbconfig'
include Config

begin
  out_file = File.expand_path("~/code/work/babylab/datavyu_scripts/data/batch_persinfo.txt")
  out = File.new(out_file, 'w')

  filedir = File.expand_path("~/code/work/babylab/opffiles")
  filenames = Dir.new(filedir).entries
  pinfo_dir = File.expand_path("~/code/work/babylab/opffiles/personal_info_files")
  no_persinfo_file_path = File.expand_path("~/code/work/babylab/opffiles/personal_info_files/batch_no_personal_info.csv")

  for file in filenames
    if file.include?(".opf")
      puts "LOADING DATABASE: " + filedir+File::SEPARATOR+file
      $db, $pj = load_db(filedir+File::SEPARATOR+file)
      puts $pj.getProjectName()
      columns = getColumnList()

      pinfo_output_path = pinfo_dir + File::SEPARATOR + $pj.getProjectName() + "_personal_info.csv"

      for column in columns
          col = getColumn(column)
  				if col.cells.length == 0
  					next
  				end
          # arrays containing millisecond onset/offsets for personal information
          audio_regions = Array.new
          video_regions = Array.new

          entry = nil
  				for cell in col.cells

            entry = cell.object.to_s
            if (entry.start_with?("%com: personal info"))
                if (entry.include?("[audio]"))
                    audio_regions.push([cell.onset, cell.offset])
                elsif (entry.include?("[video]"))
                    video_regions.push([cell.onset, cell.offset])
                else
                    puts "Malformed personal information comment:  cell#: " + cell.ordinal.to_s
                end
  				   end
            end


  				# if there are no personal info regions, add the name of the file
  				# to the no_personal_info.txt manifest
  				if (audio_regions.empty? && video_regions.empty?)
  					open(no_persinfo_file_path, "a") do |f|
  						f.puts $pj.getProjectName()
  					end
  					puts "There were no personal info regions"
  					next
  				end
  				# if already_in_nopi
  				# 	exit
  				# end
  				output_file = File.open(pinfo_output_path, "w")

          for region in audio_regions
                  output_file.puts("audio,#{region[0]},#{region[1]}")
          end

          for region in video_regions
              output_file.puts("video,#{region[0]},#{region[1]}")
          end

          output_file.close()

          puts "personal info timestamps written to: " + pinfo_output_path + "\n\n"
  	end

  end
end

end #line 3
