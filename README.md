# datavyu scripts

This repository contains a collection of ruby scripts that check to see if Datavyu entries are properly formatted. One of them, run_all_postannotation.rb, runs all the checks at the same time. You should usually run this rather than the individual scripts. Clone this repository to the local machines and select its folder as the destination to look for scripts from within Datavyu (Script -> Set Favorites Folder).

## Table of Contents
1. [Running](#running)
2. [Structure](#structure)
    * [run_all_postannotation.rb](#runall)
    * [check_codes.rb](#checkcodes)
    * [check_comments.rb](#checkcomments)
    * [check_intervals.rb](#checkintervals)
    * [personalinfo.rb](#personalinfo)


<a name='running'></a>
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

<a name='structure'></a>
## Structure

<a name='runall'></a>
1. run_all_postannotation.rb  
   This script contains copied content from the following scripts:
    * check_codes.rb
    * check_comments.rb
    * check_internvals.rb
    * personalinfo.rb
    
    and therefore performs all of the tasks done in each of the individual script for each column in the **opf** file
<a name='checkcodes'></a>
  2. check_codes.rb  
  A column name needs to be specified, and this script will perform checks on the given column only. The checks includes:  
       * Speaker length is 3
       * Speaker codes are all uppercase
       * object_present is single letter and lowercase
       * utterance_type is single letter and lowercase
       * none of the codes are empty
<a name='checkcomments'></a>
  3. check_comments.rb  
  A column name needs to be specified, and this script will perform checks on the given column only. The checks includes:
       * Every other field of a comment cell should be empty
       * The onset and offset time of a comment cell should be equal
<a name='checkintervals'></a>
  4. check_intervals.rb
  This script will perform checks on all columns. The checks includes:
       * Every non-comment cell's onset is not equal to the offset. (In fact, onset should be strictly smaller than offset)
<a name='personalinfo'></a>
  5. personalinfo.rb
  This script will perform checks on all columns. The checks includes:
       * Personal info cell must contain either video or audio info
  