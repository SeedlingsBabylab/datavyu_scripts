require 'Datavyu_API'

# $inputDir = "~/Documents/Projects/Bergelson Lab/annotation/video_with_pho"
# $outputDir = "~/Documents/Projects/Bergelson Lab/annotation/video_with_pho_output"

$inputDir = "/Volumes/pn-opus/Seedlings/Working_Files/annot_id/video/output/"
$outputDir = "/Volumes/pn-opus/Seedlings/Working_Files/annot_id/video/output_csv/"


def opf2csv(dir, file, outDir)
	$db, $pj = load_db(File.join(dir, file))
    p get_column_list[0]
    columnName = get_column_list[0]
    theColumn = get_column(columnName)
    csv_out = File.new(File.join(outDir, file.gsub('.opf', '_processed.csv')), "wb")
    csv_out.write(['labeled_object.ordinal', 'onset', 'offset', theColumn.cells[0].arglist].join(',labeled_object.')+",basic_level")
    for cell in theColumn.cells
      csv_out.write("\n#{[printCellCodes(cell)].join(',')},")
    end
    csv_out.close
end

begin
	outDir = File.expand_path($outputDir)
	dataDir = File.expand_path($inputDir)
	# retrieve used IDs

	files = Dir.new(dataDir).entries.sort
	counter = 0
	errorFile = Array.new
	for file in files
		if file.end_with? ('.opf')
			begin
				puts file
        opf2csv(dataDir, file, outDir)
			rescue
				errorFile << file
				print("Error with file: ", file, "\n")
			end
		end
		counter += 1
		print("Finished: ", counter/(files.size.to_f-2)*100, "\n")
	end

	print("Had problem with: \n")
	p errorFile
end
