require 'Datavyu_API.rb'
require 'rbconfig'
include Config

begin

	$valid_utt_type = Array["q", "d", "i", "u", "r", "s", "n", "NA"]
	$valid_obj_pres = Array["y", "n", "u", "NA"]

	def checkCodes(cell)
		if not $valid_utt_type.include?(cell.utterance_type.to_s)
			puts "Cell# "+cell.ordinal.to_s+":  \""+cell.utterance_type.to_s+"\" is not a valid utterance_type code\n"
		end
		if not $valid_obj_pres.include?(cell.object_present.to_s)
			puts "Cell# "+cell.ordinal.to_s+":  \""+cell.object_present.to_s+"\" is not a valid object_present code\n"
		end
	end


	def is_uppercase(some_string)
		return some_string == some_string.upcase
	end


	def check_mwu(cell)
		if cell.object_present.to_s != "NA"
			puts "Cell# " + cell.ordinal.to_s + ":  object_present must be NA in \"%com: mwu\" cell"
		end
		if cell.speaker.to_s != "NA"
			puts "Cell# " + cell.ordinal.to_s + ":  speaker must be NA in \"%com: mwu\" cell"
		end
	end

	columns = getColumnList()

	# Check Codes
	#
	# checkValidCodes() makes sure that all the codes found in each cell of
	# the selected column are valid codes for that specific element. The
	# function is called with the value of the "column" variable defined above.
	# You need to change this by hand every time you run it on a different column.

	# for column in columns
	# 	checkValidCodes(column, "",
	# 				"utterance_type", ["q", "d", "i", "u", "r", "s", "n", "NA"],
	# 				"object_present", ["y", "n", "u", "NA"])
	# end

	puts

	for column in columns
		col = getColumn(column)
	# Make sure that all the speaker codes are exactly 3 letters long
	# and check the case
		for cell in col.cells

			if cell.object.to_s.start_with?("%com: mwu")
				check_mwu(cell)
				next
			end

			checkCodes(cell)

			if cell.speaker.to_s.length != 3 && cell.speaker.to_s != "NA"
				puts "check codes: (3 letter code required): [Column]: "+column+"  [Variable]: speaker\t[Cell]# : "+\
					cell.ordinal.to_s + "  [Current Value]: " + cell.speaker
			end

			# Speaker code has to be all uppercase
			if !is_uppercase(cell.speaker.to_s) && !cell.object.to_s.start_with?("%com:")
				puts "check codes: speaker code must be uppercase: [Column]: " + column + " [Cell]# : "+\
				cell.ordinal.to_s
			end

			# object_present needs to be single character and lowercase
			if (cell.object_present.to_s.length != 1) && !cell.object.to_s.start_with?("%com:")
				puts "check codes: object_present needs to be a single character: [Column]: " + column + " [Cell]# : "+\
				cell.ordinal.to_s
			end

			if is_uppercase(cell.object_present.to_s) && !cell.object.to_s.start_with?("%com:")
				puts "check codes: object_present needs to be lower case: [Column]: " + column + " [Cell]# : "+\
				cell.ordinal.to_s
			end

			# utterance_type needs to be single character and lowercase
			if (cell.utterance_type.to_s.length != 1) && !cell.object.to_s.start_with?("%com:")
				puts "check codes: utterance_type needs to be a single character: [Column]: " + column + " [Cell]# : "+\
				cell.ordinal.to_s
			end

			if is_uppercase(cell.utterance_type.to_s) && !cell.object.to_s.start_with?("%com:")
				puts "check codes: utterance_type needs to be lower case: [Column]: " + column + " [Cell]# : "+\
				cell.ordinal.to_s
			end


			cell.argvals.each_with_index { |code, i|
				# codes can't be empty
				if code == ""
					puts "check_codes (Found empty code): [Column]: " + column+\
						"       [Variable]: " + cell.arglist[i].to_s + "    [Cell#]: " + cell.ordinal.to_s
				end

				# "NA" needs to be all uppercase
				if code == "na" || code =="nA" || code == "Na"
					puts "check_codes: NA needs to be uppercase: [Column]: " + column+\
						"       [Variable]: " + cell.arglist[i].to_s + "    [Cell#]: " + cell.ordinal.to_s
				end

				# codes cannot contain space, unless it's inside comment
				if !code.start_with?("%com:") and code.match(/\s/)
					puts "check_codes: code cannot contain space: [Column]: " + column+\
						"       [Variable]: " + cell.arglist[i].to_s + "    [Cell#]: " + cell.ordinal.to_s
				end
			}
		end
	end



	# Check Comments
	#
	# Make sure that comment cells don't have any content for
	# the non-comment codes. Everything except the comment itself
	# should be "NA". Also makes sure that onset/offset times for
	# comments are equal.

	for column in columns
		col = getColumn(column)
        for cell in col.cells
            if (cell.object.to_s.start_with?("%com:") &&
                    ((cell.utterance_type.to_s != "NA") ||
                     (cell.object_present.to_s != "NA") ||
                     (cell.speaker.to_s != "NA")))
								if cell.object.to_s.start_with?("%com: mwu")
									next
								end
                puts "comments ERROR: one of the values is not \"NA\": [Column] " + column + "[Cell#]: " + cell.ordinal.to_s

                if (cell.onset != cell.offset) && !(cell.object.to_s.include?("personal information"))
                    puts "comments ERROR: onset and offset are not equal: [Column] " + column + " [Cell#]: " + cell.ordinal.to_s
                end

            elsif (cell.object.to_s.start_with?("%com:") &&
                   (cell.onset != cell.offset) && !(cell.object.to_s.include?("personal information")))
                puts "comments ERROR: onset and offset are not equal: [Column] " + column + " [Cell#]: " + cell.ordinal.to_s
            end
        end
	end



	# Check Intervals
	#
	# this makes sure all onsets are < offsets
	#	scan_for_bad_cells(col)
	for column in columns
		col = getColumn(column)
		for cell in col.cells

			if cell.onset > cell.offset
				puts "intervals ERROR: onset is greater than offset: [Column] " + column + " [Cell#]: " + cell.ordinal.to_s

			end
			if !cell.object.to_s.start_with?("%com") && (cell.onset == cell.offset)
				puts "intervals ERROR: onset and offset are equal in non-comment cell: [Column] " + column + " [Cell#]: " + cell.ordinal.to_s
			end
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

	#File.readlines(no_persinfo_file_path).each do |puts line|
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



end
