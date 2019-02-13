require 'Datavyu_API'
require 'securerandom'

""" NOTE """

"""
A lot of this is not necessary but I copied another script and have to clean this one but not done yet
"""

# $inputDir = "~/Documents/Projects/Bergelson Lab/annotation/video_with_pho"
# $outputDir = "~/Documents/Projects/Bergelson Lab/annotation/video_with_pho_output"

$inputDir = "/Volumes/pn-opus/Seedlings/Working_Files/annot_id/video/opf_sc/"
$outputDir = "/Volumes/pn-opus/Seedlings/Working_Files/annot_id/video/output/"
$usedIDFile = "/Volumes/pn-opus/Seedlings/usedID.txt"
# $usedIDFile = "/Volumes/pn-opus/Seedlings/Working_Files/annot_id/video/usedID.txt"

def randomID
	randID = SecureRandom.uuid
	randID = "0x"+randID[0..5]
	while($usedID.include?(randID))
		p "ID Collision"
		randID = SecureRandom.uuid
		randID = "0x"+randID[0..5]
	end
  p randID
	$usedID << randID
	return randID
end

def printCode(*code)
	columnName = get_column_list[0]
   	theColumn = get_column(columnName)
   	for cell in theColumn.cells
   		p cell.get_codes(code)
   	end
end

def addID(dir, outDir)
	# $db, $pj = load_db(File.join(dir, file))
   	columnName = getColumnList()
   	theColumn = getColumn(columnName[0])
		unless theColumn.arglist.include? "id"
   		theColumn.add_code('id')
		end
   	for cell in theColumn.cells
			if cell.get_code('id').to_s.strip.nil? || cell.get_code('id').to_s.strip.empty?
				p cell.get_code('id')
   			cell.change_code('id', randomID)
			end
   	end
   	set_column(theColumn)
   	# save_db(File.join(outDir, file))
end

begin
	outDir = File.expand_path($outputDir)
	dataDir = File.expand_path($inputDir)
	# retrieve used IDs
	$usedID = Set.new
	fID = open $usedIDFile
	fID.each do |line|
		$usedID << line
	end
	files = Dir.new(dataDir).entries.sort
	counter = 0
	errorFile = Array.new

	addID(dataDir, outDir)

	# File.open(File.join(outDir, 'usedID.txt'), 'w') {
	File.open($usedIDFile, 'w') {
		|file|
		for id in $usedID
			file.write(id + "\n")
		end
	}
	print("Had problem with: \n")
	p errorFile
end
