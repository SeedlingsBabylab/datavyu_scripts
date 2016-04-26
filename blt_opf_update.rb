require 'Datavyu_API.rb'
require 'rbconfig'
include Config

begin

  diff_file = File.expand_path("~/Desktop/opf_diffs.csv")


  def cells_match(diff, cell)
    if (diff.onset == cell.onset.to_s) &&\
      (diff.offset == cell.offset.to_s) &&\
      (diff.object == cell.object.to_s) &&\
      (diff.utt_type == cell.utterance_type.to_s) &&\
      (diff.present == cell.object_present.to_s) &&\
      (diff.speaker == cell.speaker.to_s)
      return true
    end
    return false
  end

  def update_diff(diff, cell)
    if diff.object_edit
      cell.change_code("object", diff.object_edit)
    end
  end


class Diff
  attr_accessor :opf_path, :ordinal, :onset, :offset, :object, :utt_type, :present, :speaker,
                 :object_edit, :utt_edit, :present_edit, :speaker_edit

  def initialize(opf_path, ordinal, onset,
                 offset, object, utt_type,
                 present, speaker, object_edit,
                 utt_edit, present_edit, speaker_edit)

    @opf_path = opf_path
    @ordinal = ordinal
    @onset = onset
    @offset = offset
    @object  = object
    @utt_type = utt_type
    @present = present
    @speaker = speaker
    @object_edit = object_edit
    @utt_edit = utt_edit
    @present_edit = present_edit
    @speaker_edit = speaker_edit
  end
end


  opf_files = Array.new

  csv_data = CSV.read(diff_file)[1 .. -1]

  diffs = Array.new
  for element in csv_data
    diff = Diff.new(element[0], element[1],element[2],
                    element[3], element[4], element[5],
                    element[6], element[7], element[8],
                    element[9], element[10], element[11])

    diffs.push(diff)
  end

  puts diffs

  for diff in diffs
    puts diff.opf_path
    opf_file = File.expand_path(diff.opf_path)
    puts "LOADING DATABASE: " + opf_file
    $db, $pj = load_db(opf_file)
    puts $pj.getProjectName()
    columns = getColumnList()
    #puts element

    for column in columns
      col = getColumn(column)
      if col.cells.length == 0
        next
      end

      for cell in col.cells
        if cells_match(diff, cell)
          #puts cell.to_s
        end
      end
    end
  end

end
