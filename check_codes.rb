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
		cell.argvals.each_with_index { |code, i|
			if code == ""
				puts "check_codes ERROR (Found empty code):       Variable: " + cell.arglist[i].to_s + "    Cell# : " + cell.ordinal.to_s
			end
		}
	end
end
