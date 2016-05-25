require 'Datavyu_API.rb'
require 'rbconfig'
# This script runs through the datavyu file
# and pulls out all the personal info comments.
# It then writes out a file containing the
# timestamps of those regions. That output file
# should then be fed into the program that actually
# does the silencing.
#
#
# These comments should take the form:
#
#   %com: personal information [audio]: credit card number
#
# or
#
#   %com: personal information [video]: butt
#
#
begin
	columns = getColumnList()



		output_path = $pj.getProjectDirectory() + File::SEPARATOR + $pj.getProjectName() + "_personal_info.csv"
		output_path.gsub!('\\', '/')

		split_path = output_path.split(File::SEPARATOR)

		case RbConfig::CONFIG['host_os']
		when /mswin|windows/i
			no_persinfo_file_path = File.join(split_path[0], "Scripts_and_Apps/no_personal_info.txt")
		else
			no_persinfo_file_path = "/Volumes/seedlings/Scripts_and_Apps/no_personal_info.txt"
		end

	for column in columns

        col = getColumn(column)

        # arrays containing millisecond onset/offsets for personal information
        audio_regions = Array.new
        video_regions = Array.new

        entry = nil
				for cell in col.cells
            entry = cell.object.to_s
            if (entry.start_with?("%com: personal info"))
                if (entry.include?("[audio]"))
                    audio_regions.push([cell.onset, cell.offset])
								end

                if (entry.include?("[video]"))
                    video_regions.push([cell.onset, cell.offset])
								end

                if (!(entry.include?("[audio]") || entry.include?("[video]")))
                    puts "Malformed personal information comment:  cell#: " + cell.ordinal.to_s
								end

            end

					end
		end

		# if there are no personal info regions, add the name of the file
		# to the no_personal_info.txt manifest in /seedlings/Scripts_and_Apps/
		if (audio_regions.empty? && video_regions.empty?)
			open(no_persinfo_file_path, "a") do |f|
				f.puts $pj.getProjectName()
			end
			puts "There were no personal info regions"
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
