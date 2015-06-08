#datavyu scripts

This repository contains a collection of ruby scripts that check to see if Datavyu entries are properly formatted. One of them, run_all.rb, runs all the checks at the same time. You should usually run this rather than the individual scripts. Clone this repository to the local machines and select its folder as the destination to look for scripts from within Datavyu (Script -> Set Favorites Folder).

##running

There's a variable named column at the top of the run_all.rb script which should be adjusted by hand when running. It looks like this:

```ruby
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



```

Each individual script also has this variable. For example (from personalinfo.rb):


```ruby

begin

	column = "labeled_object_GC"	# set this as necessary

	output = File.expand_path("~/desktop/maskregions.txt") # set this as necessary

	col = getColumn(column)

	# arrays containing millisecond onset/offsets for personal information
	audio_regions = Array.new
	video_regions = Array.new

```

You should run these scripts once you've finished coding. Usually this means running run_all.rb rather than each individual script. They're separated into 4 distinct programs with multiple checks per script:

1. check_codes.rb
  * entered values are one of the predefined codes
  * speaker code is exactly 3 letters long
  * none of the codes are empty
2. check_comments.rb
  * all of the non-comment codes are "NA"
  * offset and onset are equal
3. check_intervals.rb
  * all onsets come prior to offsets
4. personalinfo.rb
  * parses out the personal info timestamps and writes them out to a .csv file



You can run them by double clicking their names in the bottom left corner in Datavyu.


![datavyu_scripts](data/datavyu_scripts_screen.png)
