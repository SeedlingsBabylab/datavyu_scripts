require 'Datavyu_API.rb'
require 'rbconfig'
include Config

begin
  out_file = File.expand_path("~/code/work/babylab/datavyu_scripts/data/batch_persinfo.txt")
  out = File.new(out_file, 'w')

  filedir = File.expand_path("~/code/work/babylab/opffiles")
  filenames = Dir.new(filedir).entries

  for file in filenames

    puts "LOADING DATABASE: " + file












    	output_path = $pj.getProjectDirectory() + File::SEPARATOR + $pj.getProjectName() + "_personal_info.csv"
    	output_path.gsub!('\\', '/')

    	split_path = output_path.split(File::SEPARATOR)

    	case CONFIG['host_os']
    	when /mswin|windows/i
    		no_persinfo_file_path = File.join(split_path[0], "Scripts_and_Apps/no_personal_info.txt")
    	else
    		no_persinfo_file_path = "/Volumes/seedlings/Scripts_and_Apps/no_personal_info.txt"
    	end
    	#puts output_path
    	#output = File.expand_path(output_path)

    	no_pi = IO.readlines(no_persinfo_file_path)
    	already_in_nopi = false
    	for element in no_pi
    		if element.include? $pj.getProjectName()
    			already_in_nopi = true
    		end
    	end
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
    				# to the no_personal_info.txt manifest in /seedlings/Scripts_and_Apps/
    				if (audio_regions.empty? && video_regions.empty? && !already_in_nopi)
    					open(no_persinfo_file_path, "a") do |f|
    						f.puts $pj.getProjectName()
    					end
    					puts "There were no personal info regions"
    					exit
    				end
    				if already_in_nopi
    					exit
    				end
    				output_file = File.open(output_path, "w")

            for region in audio_regions
                    output_file.puts("audio,#{region[0]},#{region[1]}")
            end

            for region in video_regions
                output_file.puts("video,#{region[0]},#{region[1]}")
            end

            output_file.close()

            puts "personal info timestamps written to: " + output_path + "\n\n"
    	end
















  end #line 10

end #line 3
