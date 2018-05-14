quit -sim
project compileall
vsim -gui work.system
mem load -i output.mem /system/Ram_Instance/ram_memory_s
add wave -position insertpoint sim:/system/*
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/general_state_input_counter_enable_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/output_window_index_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/input_window_row_index_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/data_cache_output_window_index_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/data_cache_input_window_row_index_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/data_cache_enable_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/data_cache_read_write_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/dma_enable_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/dma_read_write_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/filter_cache_enable_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/filter_cache_index_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/dma_increment_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/alu_enable_out
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/output_counter_enable_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/input_counter_enable_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/filter_counter_enable_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/filter_counter_done_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/input_counter_done_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/output_counter_done_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/initilization_state_input_counter_enable_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/init_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/state_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/new_state_s
add wave -position end  sim:/system/DCNN_Instance/CU_Instance/num_lines_read_s
force -freeze sim:/system/clk_c 1 0, 0 {50 ps} -r 100
run 5
force -freeze sim:/system/reset_in 1 0
run 20
force -freeze sim:/system/reset_in 0 0
force -freeze sim:/system/start_in 1 0
force -freeze sim:/system/filter_size_in 1 0
force -freeze sim:/system/stride_in 1 0
force -freeze sim:/system/instruction_in 0 0
run 75
run 2915100 ps
mem save -o input.mem -f mti -data decimal -addr decimal -startaddress 0 -endaddress 129064 -wordsperline 1 /system/Ram_Instance/ram_memory_s
