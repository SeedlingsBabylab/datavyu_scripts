###################################################################################
# Script to add a coding column for the labeled_object pass. 
# Creates one new column with four arguments

# Joshua Schneider
# Bergelson Lab
# November 2, 2015
# #################################################################################
require 'Datavyu_API.rb'

begin
	#Create new column
	labeled_object = createNewColumn("labeled_object", "object","utterance_type","object_present","speaker")
	
  #Write the new column to Datavyu's spreadsheet
	setColumn(labeled_object)
end	
