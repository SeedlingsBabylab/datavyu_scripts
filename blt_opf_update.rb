require 'Datavyu_API.rb'
require 'rbconfig'
include Config

begin



  ################################
  # You need to set this path ~> #
  ################################
  path_to_opf_diffs_file = "~/Desktop/opf_diffs.csv"







  diff_file = File.expand_path(path_to_opf_diffs_file)

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

  def update_diff(diff, cell, col, column)
    if diff.object_edit != nil
      cell.change_code("object", diff.object_edit)
      setColumn(column, col)
    end
    if diff.utt_edit != nil
      cell.change_code("utterance_type", diff.utt_edit)
      setColumn(column, col)
    end
    if diff.present_edit != nil
      cell.change_code("object_present", diff.present_edit)
      setColumn(column, col)
    end
    if diff.speaker_edit != nil
      cell.change_code("speaker", diff.speaker_edit)
      setColumn(column, col)
    end
  end


class Diff
  attr_accessor :opf_path, :ordinal, :onset,
                :offset, :object, :utt_type,
                :present, :speaker, :object_edit,
                :utt_edit, :present_edit, :speaker_edit,
                :onset_int, :filename

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
    @onset_int = onset.to_i
    @filename = opf_path.split(File::SEPARATOR)[-1]
  end
end

  csv_data = CSV.read(diff_file)[1 .. -1]

  diffs = Array.new

  for element in csv_data
    diff = Diff.new(element[0], element[1],element[2],
                    element[3], element[4], element[5],
                    element[6], element[7], element[9],
                    element[10], element[11], element[12])

    diffs.push(diff)
  end

  diffs = diffs.sort_by{|obj| obj.onset_int}
  diff_groups = diffs.group_by{|obj| obj.opf_path}

  diff_groups.each do |key, value|
    opf_file = File.expand_path(key)
    $db, $pj = load_db(opf_file)

    puts "\nLOADING DATABASE: " + $pj.getProjectName()
    puts "updated entries: \n\n"

    for diff in value
      columns = getColumnList()

      for column in columns
        col = getColumn(column)

        if col.cells.length == 0
          next
        end

        for cell in col.cells
          if cells_match(diff, cell)
            update_diff(diff, cell, col, column)
            cell.print_all()
            puts
          end
        end
        save_db(diff.opf_path.sub!(".opf", "_bl_tidy.opf"))
      end
    end
  end
end
