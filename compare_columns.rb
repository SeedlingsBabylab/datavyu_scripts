require 'Datavyu_API.rb'
begin

filepathFrom = File.expand_path("~/Desktop/corpus_files/01_07_coderEB.opf")
    filepathTo = File.expand_path("~/Desktop/corpus_files/01_07_coderSK.opf")
    transfer_columns(filepathFrom, filepathTo, false, "labeled_object_EB")

end
