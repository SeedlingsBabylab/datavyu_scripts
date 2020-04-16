
### Cell creation with new data
def newcell_nouns(col, obj, t1, t2)
  cell = col.make_new_cell()
  cell.change_code("object", obj)
  cell.change_code("onset", t1)
  cell.change_code("offset", t2)
end

chafiles = getColumn("chafile_info")
col = createColumn("nouns", "object", "utt", "op", "talker")


for cell in chafiles.cells
  analysis = cell.analysis
  ### SPECIAL CASE if n| at the very beginning
  if analysis[0..1]=="n|"
    val = analysis[2..-1].split(" ")[0]
    newcell_nouns(col, val, cell.onset, cell.offset)
  end

  ### For the rest
  tmp = analysis.split(" n|") # split at noun marker (/!\ first space necessary)
  if tmp.length>1 # if this split led to several pieces
    for item in tmp[1..-1] # for every piece but the first
      # each item is something between two occurences of n|
      # => we take the beginning up to the first space
      newcell_nouns(col, item.split(" ")[0], cell.onset, cell.offset)
    end
  end
end

setColumn(col)
