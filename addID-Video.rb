require 'Datavyu_API'
require 'securerandom'

$inputDir = "~/Documents/Projects/Bergelson Lab/annotation/video"
$outputDir = "~/Documents/Projects/Bergelson Lab/annotation/videoOutput"

def randomID
	randID = SecureRandom.uuid
	return randID[0..7] + randID[9]
end

def printCode(*code)
	columnName = get_column_list[0]
   	theColumn = get_column(columnName)
   	for cell in theColumn.cells
   		p cell.get_codes(code)
   	end
end

def addID(dir, file, outDir)
	$db, $pj = load_db(File.join(dir, file))
   	columnName = get_column_list[0]
   	theColumn = get_column(columnName)
   	theColumn.add_code('id')
   	for cell in theColumn.cells
   		cell.change_code('id', randomID)
   	end
   	set_column(theColumn)
   	save_db(File.join(outDir, file))
end

begin
   	outDir = File.expand_path($outputDir)
	dataDir = File.expand_path($inputDir)
	files = Dir.new(dataDir).entries.sort
	counter = 0
	errorFile = []
	for file in files
		if file.end_with? ('.opf')
			begin
				addID(dataDir, file, outDir)
			rescue
				errorFile.append(file)
				print("Error with file: ", file, "\n")
			end
		end
		counter += 1
		print("Finished: ", counter/(files.size.to_f-2)*100, "\n")
	end
	print("Had problem with: \n")
	p errorFile
end
