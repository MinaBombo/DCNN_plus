load_library tsmc035_typ
read -dont_elaborate {"../Utils/DataTypes.vhd" "../Utils/nBitsDecoder.vhd" "../CU/OutputWindowIndexCounter.vhd" "../CU/InputWindowRowIndexCounter.vhd" "../CU/CU.vhd" "../CU/FilterCounter.vhd"  "../DMA/ReadAddressCounter.vhd" "../DMA/WriteAddressCounter.vhd" "../DMA/DMA.vhd" "../Caches/DataCache.vhd" "../Caches/FilterCache.vhd" "../ALU/Adder.vhd" "../ALU/Multiplier/BoothBuffer.vhd" "../ALU/Multiplier/Multiplier.vhd" "../ALU/Multiplier/BoothPipeline.vhd" "../ALU/Multiplier/Booth.vhd" "../ALU/WindowBuffer.vhd" "../ALU/ALU.vhd" "../DCNN.vhd"}

elaborate DCNN -architecture dcnn_arch 
set register2register 1000.000000
set input2register 1000.000000
set register2output 1000.000000
optimize .work.DCNN.dcnn_arch -target tsmc035_typ -chip -area -effort quick -hierarchy flatten 
optimize_timing .work.DCNN.dcnn_arch -force 
report_delay delay_report.txt -num_paths 1 -critical_paths -clock_frequency
report_area area_report.txt -cell_usage -all_leafs
set novendor_constraint_file FALSE
auto_write -format Verilog DCNN_v4.v