require 'Datavyu_API'


#
# def parent_conditions(pho, chi)
#   if chi.speaker.to_s != "CHI" && !(chi.object.to_s.start_with? "%com: mwu")
#     return false
#   else
#     return true
#   end
# end


begin

col = get_column("child_labeled_object")


col.cells.each_with_index do |cell, i|
  if cell.object.to_s.start_with? "%pho"
    parent = col.cells[i-1]
    cell.print_all()
    puts()
    parent.print_all()
    puts("\n\n")
    # if !parent_conditions(cell, parent)
    #   puts("\n")
    #   puts("\n******************************")
    #   puts("\tparent cell was wrong")
    #   puts("******************************")
    #   exit
    # else
      cell.onset = parent.onset
      cell.offset = parent.offset
    # end
  end

set_column(col)
end





# for cell in col.cells
#   if cell.object.to_s.start_with? "%pho"
#     for parent_cell in col.cells
#     puts(cell.object)
#   end
# end
end
