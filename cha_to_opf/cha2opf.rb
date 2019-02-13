

"""
Get useful lines : *... , utterance, onset, offset // %mor analysis
"""

### PATH TO CHANGE ###
file = File.open("/Users/bergelsonlab/Downloads/HL/13/52CC_13.cha", "r")

useful_lines = []

file.each do |line|
  if line[0]=='*'
    tmp = line.rpartition(" ") # split at the last space of the line
    time = tmp[-1].split('_') # split the last cell (containing onset_offset) at _

    useful_lines << [tmp[0], Integer(time[0][1..-1]), Integer(time[1][0..-3])] #substrings to remove bulletpoints and \n
  else
    if line[0..3]=="%mor"
      useful_lines << [line, -1, -1]
    end
  end
end

"""
Fill spreadsheet
"""

col = createColumn("chafile_info", "utterance", "analysis")

### Create and fill new cell
def newcell_chafile(col, utt, analysis, t1, t2)
  cell = col.make_new_cell()
  cell.change_code("utterance", utt)
  cell.change_code("analysis", analysis)
  cell.change_code("onset", t1)
  cell.change_code("offset", t2)
end

### For each line in useful_lines
for utt in 0..useful_lines.length-2 do
  # If it starts with *
  if useful_lines[utt][0][0]=="*"
    # Retrieve data in useful_lines
    t1 = useful_lines[utt][1]
    t2 = useful_lines[utt][2]
    utterance=useful_lines[utt][0]
    analysis=""
    # If there is an associated % line, add it
    if useful_lines[utt+1][0][0]=="%"
      analysis=useful_lines[utt+1][0]
    end
    # Create corresponding cell
    newcell_chafile(col, utterance, analysis, t1, t2)
  end
end

setColumn(col)
