require 'Datavyu_API.rb'

# This script runs through the datavyu file
# and pulls out all the personal info comments.
# It then writes out a file containing the
# timestamps of those regions. That output file 
# should then be fed into the program that actually 
# does the silencing. 

begin

	column = "labeled_object_GC"	# set this as necessary

	output = File.expand_path("~/desktop/muteregions.txt") # set this as necessary
	
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
			elsif (entry.include?("[video]"))
				video_regions.push([cell.onset, cell.offset])
			else
				puts "Malformed personal information comment:  cell#: " + cell.ordinal.to_s
			end
		end
	end

	output_file = File.open(output, "w")

	for region in audio_regions
			output_file.puts("audio,#{region[0]},#{region[1]}")
	end

	for region in video_regions
		output_file.puts("video,#{region[0]},#{region[1]}")
	end

	output_file.close()
	
end

