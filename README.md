# datavyu scripts

This repository contains a collection of ruby scripts that check to see if Datavyu entries are properly formatted. One of them, run_all_postannotation.rb, runs all the checks at the same time. You should usually run this rather than the individual scripts. Clone this repository to the local machines and select its folder as the destination to look for scripts from within Datavyu (Script -> Set Favorites Folder).

## running

To run the run_all_postannotation.rb script, simply double click it in the scripts box in the bottom left hand corner of the main Datavyu window.


The individual scripts have a variable named "column" that need to be adjusted by hand. These scripts will be updated to run without making the adjustment soon. For example (from personalinfo.rb):


```ruby

begin

	column = "labeled_object_GC"	# set this as necessary

	output = File.expand_path("~/desktop/maskregions.txt") # set this as necessary

	col = getColumn(column)

	# arrays containing millisecond onset/offsets for personal information
	audio_regions = Array.new
	video_regions = Array.new

```

You should run these scripts once you've finished coding. Usually this means running run_all_postannotation.rb rather than each individual script. They're separated into 4 distinct programs with multiple checks per script:

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
