###################################################################################
# Script to change speaker codes within .opf files (e.g. MOT to FAT for each instance of MOT)
# Actually replaces whole column with new column, so only work from a copied version

# EB edited JS script, based on Anastasia Bui script from NYU,Fix-MomMovement.rb, 8/15
# Bergelson Lab
# June 20, 2016
# #################################################################################

require 'Datavyu_API.rb'

begin
### if column called labeled_object, do nothing, but if it's NOT
### Change "labeled_object" to the column name, e.g. "labeled_object_GC"
    labeled_object = getVariable("labeled_object")

### mvcell.speaker=="YYY" where YYY is the current speaker value
### mvcell.change_arg("speaker", "XXX") where XXX is what it should change to
    for mvcell in labeled_object.cells
        if mvcell.speaker=="BRO"
         mvcell.change_arg("speaker", "BR1")

    end
end

    setVariable(labeled_object)
    puts "Cell names replaced."
end