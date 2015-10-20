require 'Datavyu_API.rb'

begin

	column = "labeled_object_GC"	# set this as necessary


	# checkValidCodes() makes sure that all the codes found in each cell of
	# the selected column are valid codes for that specific element. The
	# function is called with the value of the "column" variable defined above.
	# You need to change this by hand every time you run it on a different column.

	checkValidCodes(column, "",
				"utterance_type", ["q", "d", "i", "u", "r", "s", "n", "NA"],
				"object_present", ["y", "n", "u", "NA"])

	puts

	col = getColumn(column)

	# Make sure that all the speaker codes are exactly 3 letters long
	for cell in col.cells
		if cell.speaker.to_s.length != 3
			puts "check_codes ERROR (3 letter code required): Variable: speaker\t      Cell# : " +\
			   	cell.ordinal.to_s + "   Current Value: " + cell.speaker
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
			if code == ""
				puts "check_codes ERROR (Found empty code):       Variable: " + cell.arglist[i].to_s + "    Cell# : " + cell.ordinal.to_s
			end

			# "NA" needs to be all uppercase
			if code == "na" || code =="nA" || code == "Na"
				puts "check_codes: NA needs to be uppercase: [Column]: " + column +\
					"       [Variable]: " + cell.arglist[i].to_s + "    [Cell#]: " + cell.ordinal.to_s
			end

			# codes cannot contain space, unless it's inside comment
			if !code.start_with?("%com:") and code.match(/\s/)
				puts "check_codes: code cannot contain space: [Column]: " + column +\
					"       [Variable]: " + cell.arglist[i].to_s + "    [Cell#]: " + cell.ordinal.to_s
			end
		}
	end
end
