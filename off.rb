require 'Datavyu_API'

output_folder = "~/Documents/GitHub/datavyu_scripts/output/"
csv_path = "~/Documents/GitHub/datavyu_scripts/output/17_16_video_sparse_code.csv"


begin
  csv_file = File.expand_path(csv_path)
  csv_data = CSV.read(csv_file)
  col_name = csv_data[0][0].split('.')[0]
  puts col_name
  code_list = Array.new

  new_column = create_new_column(col_name)
  for n in 0..(csv_data[0].length-1) do
    code = csv_data[0][n].split('.')[1]
    new_column.add_code(code)
    code_list << code
  end

  for k in 1..(csv_data.length-1) do
    newcell = new_column.make_new_cell()
    for n in 0..(csv_data[0].length-1) do
      if (code_list[n] == "ordinal") or (code_list[n] == "onset") or (code_list[n] == "offset") then
        newcell.change_code(code_list[n], csv_data[k][n].to_i)
      else
        newcell.change_code(code_list[n], csv_data[k][n])
      end
    end
  end

  setColumn(new_column)

  save_db(File.join(File.expand_path(output_folder), csv_path.sub!(".csv", ".opf")))


end
