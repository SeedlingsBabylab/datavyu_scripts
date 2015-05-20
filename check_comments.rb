require 'Datavyu_API.rb'

begin
	column = "labeled_object_GC"	# set this as necessary


	col = getColumn(column)


	# Make sure that comment cells don't have any content for
	# the non-comment codes. Everything except the comment itself
	# should be "NA". Also makes sure that onset/offset times for
	# comments are equal.

	for cell in col.cells

		if (cell.object.to_s.start_with?("%com:") &&
				((cell.utterance_type.to_s != "NA") ||
				 (cell.object_present.to_s != "NA") ||
				 (cell.speaker.to_s != "NA")))

			puts "check_comments ERROR: one of the values is not \"NA\":   Cell#: " + cell.ordinal.to_s

			if (cell.onset != cell.offset)
				puts "check_comments ERROR: onset and offset are not equal:  Cell#: " + cell.ordinal.to_s
			end
		end
	end
end
