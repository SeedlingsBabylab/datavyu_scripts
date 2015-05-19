#datavyu scripts

This repository contains a collection of ruby scripts that check to see if Datavyu entries are properly formatted. You should clone this repository to the local machines and select its folder as the destination to look for scripts from within Datavyu (Script -> Set Favorites Folder).

##running

Each script has a variable named "column" which should be adjusted by hand when running. For example (from check_codes.rb):


```ruby
begin

	column = "labeled_object_GC"	# set this as necessary


	# checkValidCodes() makes sure that all the codes found in each cell of
	# the selected column are valid codes for that specific element. The
	# function is called with the value of the "column" variable defined above.
	# You need to change this by hand every time you run it on a different column.

	checkValidCodes(column, "",
				"utterance_type", ["q", "d", "i", "u", "r", "s", "n"],
				"object_present", ["y", "n"])
```
