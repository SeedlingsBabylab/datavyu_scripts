require 'Datavyu_API'


$percent = 0.10

$input_dir  = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/input_orig"
$output_dir_cprod = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/recode_out_cprod"
$output_dir_attobj = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/recode_out_attobj"
$original_out_cprod = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/orig_out_cprod"
$original_out_attobj = "~/code/work/bergelsonlab/pho_checks/opf_chi_cv4/orig_out_attobj"


def recode(in_dir, file)
    puts(file)
    $db, $pj = load_db(File.join(in_dir, file))

    vocalization_col = "Infant_vocalization"
    col = get_column(vocalization_col)

    annotation_cells = col.cells.select do |elem|
        elem.type.to_s.start_with? "C"
    end
    if annotation_cells.empty?
        next
    end

    n = annotation_cells.size * $percent
    if n < 1
        n = n.ceil
    else
        n = n.round
    end

    start = rand(0..annotation_cells.size-n)
    randrange = annotation_cells.size-1-n
    puts("full size: #{col.cells.size}  annot_cells: #{annotation_cells.size}  randrange: #{randrange}  n: #{n}   start: #{start}   end: #{start+n} ")

  recode_slice = annotation_cells[start..start+(n-1)]

    ###########################################
    # output blank 10% child_prod annotations #
    ###########################################
    new_column = create_new_column("recode_child_prod", "child_prod", "orig_ordinal")
    for cell in recode_slice
        newcell = new_column.make_new_cell()
        newcell.change_code("onset", cell.onset)
        newcell.change_code("offset", cell.offset)
        newcell.change_code("child_prod", "NA")
        newcell.change_code("orig_ordinal", cell.ordinal)
    end

    columns = get_column_list()

    for colu in columns
        delete_variable(colu)
    end
    set_column(new_column)
    save_db(File.join(File.expand_path($output_dir_cprod), file.sub(".opf", "_cprod_recode.opf")))
    delete_variable(new_column)

    #########################################
    #  output blank 10% att_obj annotations #
    #########################################
    new_column = create_new_column("recode_att_obj", "attended_object", "orig_ordinal")
    for cell in recode_slice
        newcell = new_column.make_new_cell()
        newcell.change_code("onset", cell.onset)
        newcell.change_code("offset", cell.offset)
        newcell.change_code("attended_object", "NA")
        newcell.change_code("orig_ordinal", cell.ordinal)
    end

    columns = get_column_list()

    for colu in columns
        delete_variable(colu)
    end
    set_column(new_column)
    save_db(File.join(File.expand_path($output_dir_attobj), file.sub(".opf", "_attobj_recode.opf")))
    delete_variable(new_column)


    ##############################################
    # output original 10% child_prod annotations #
    ##############################################
    new_column = create_new_column("original_child_prod", "child_prod", "orig_ordinal")
    for cell in recode_slice
        newcell = new_column.make_new_cell()
        newcell.change_code("child_prod", cell.ctype)
        newcell.change_code("orig_ordinal", cell.ordinal)
        newcell.change_code("onset", cell.onset)
        newcell.change_code("offset", cell.offset)
    end

    set_column(new_column)
    save_db(File.join(File.expand_path($original_out_cprod), file.sub(".opf", "_cprod_recode_orig.opf")))
    delete_variable(new_column)

    ############################################
    #  output original 10% att_obj annotations #
    ############################################
    new_column = create_new_column("original_att_object", "attended_object", "orig_ordinal")
    for cell in recode_slice
        newcell = new_column.make_new_cell()
        newcell.change_code("attended_object", cell.object)
        newcell.change_code("orig_ordinal", cell.ordinal)
        newcell.change_code("onset", cell.onset)
        newcell.change_code("offset", cell.offset)
    end

    set_column(new_column)
    save_db(File.join(File.expand_path($original_out_attobj), file.sub(".opf", "_attobj_recode_orig.opf")))
    delete_variable(new_column)
end


begin
  in_dir = File.expand_path($input_dir)
  filenames = Dir.new(in_dir).entries

  for file in filenames
    if file.end_with? ".opf"
      recode(in_dir, file)
    end
  end
end
