require 'Datavyu_API.rb'

begin
	
	column = "labeled_object_GC"	# set this as necessary

	# Check Codes
	# 
	# checkValidCodes() makes sure that all the codes found in each cell of
	# the selected column are valid codes for that specific element. The
	# function is called with the value of the "column" variable defined above.
	# You need to change this by hand every time you run it on a different column.

	checkValidCodes(column, "",
				"utterance_type", ["q", "d", "i", "u", "r", "s", "n", "NA"],
				"object_present", ["y", "n", "NA"])

	puts

	col = getColumn(column)

	# Make sure that all the speaker codes are exactly 3 letters long
	for cell in col.cells
		if cell.speaker.to_s.length != 3 && cell.speaker.to_s != "NA"
			puts "check_codes ERROR (3 letter code required): Variable: speaker\t      Cell# : " +\
			   	cell.ordinal.to_s + "   Current Value: " + cell.speaker
		end
		cell.argvals.each_with_index { |code, i|
			if code == ""
				puts "check_codes ERROR (Found empty code):       Variable: " + cell.arglist[i].to_s + "    Cell# : " + cell.ordinal.to_s
			end
		}
	end




	# Check Comments
	#
	# Make sure that comment cells don't have any content for
	# the non-comment codes. Everything except the comment itself
	# should be "NA". Also makes sure that onset/offset times for
	# comments are equal.

	for cell in col.cells

		if (cell.object.to_s.start_with?("%com:") &&
				((cell.utterance_type.to_s != "NA") ||
				 (cell.object_present.to_s != "NA") ||
				 (cell.speaker.to_s != "NA")))

			puts "comments ERROR: one of the values is not \"NA\":   Cell#: " + cell.ordinal.to_s

			if (cell.onset != cell.offset) && !(cell.object.to_s.include?("personal information"))
				puts "comments ERROR: onset and offset are not equal:  Cell#: " + cell.ordinal.to_s
			end
		
		elsif (cell.object.to_s.start_with?("%com:") &&
			   (cell.onset != cell.offset) && !(cell.object.to_s.include?("personal information")))
			puts "comments ERROR: onset and offset are not equal:  Cell#: " + cell.ordinal.to_s
		end
	end



	# Check Intervals
	# 
	# this makes sure all onsets are < offsets
	#	scan_for_bad_cells(col)

	for cell in col.cells

		if cell.onset > cell.offset
			puts "intervals ERROR: onset is greater than offset:  Cell#: " + cell.ordinal.to_s

		end
	end
	puts "\n\n\n"

	
	# Personal Info
	#
	# This part runs through the datavyu file
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
	#  You need to set the output path of the .csv file that 
	#  will be generated. This is the first line after this comment 

	output_path = "~/desktop/maskregions.csv" # set this as necessary

	output = File.expand_path(output_path) 	
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

	puts "personal info timestamps written to: " + output_path + "\n\n"
end
