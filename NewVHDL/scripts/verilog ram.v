module RAM ( enable_in, clk_c, read_write_in, address_in, data_in, data_out_4__7, 
             data_out_4__6, data_out_4__5, data_out_4__4, data_out_4__3, 
             data_out_4__2, data_out_4__1, data_out_4__0, data_out_3__7, 
             data_out_3__6, data_out_3__5, data_out_3__4, data_out_3__3, 
             data_out_3__2, data_out_3__1, data_out_3__0, data_out_2__7, 
             data_out_2__6, data_out_2__5, data_out_2__4, data_out_2__3, 
             data_out_2__2, data_out_2__1, data_out_2__0, data_out_1__7, 
             data_out_1__6, data_out_1__5, data_out_1__4, data_out_1__3, 
             data_out_1__2, data_out_1__1, data_out_1__0, data_out_0__7, 
             data_out_0__6, data_out_0__5, data_out_0__4, data_out_0__3, 
             data_out_0__2, data_out_0__1, data_out_0__0 ) ;

    input enable_in ;
    input clk_c ;
    input read_write_in ;
    input [18:0]address_in ;
    input [7:0]data_in ;
    output data_out_4__7 ;
    output data_out_4__6 ;
    output data_out_4__5 ;
    output data_out_4__4 ;
    output data_out_4__3 ;
    output data_out_4__2 ;
    output data_out_4__1 ;
    output data_out_4__0 ;
    output data_out_3__7 ;
    output data_out_3__6 ;
    output data_out_3__5 ;
    output data_out_3__4 ;
    output data_out_3__3 ;
    output data_out_3__2 ;
    output data_out_3__1 ;
    output data_out_3__0 ;
    output data_out_2__7 ;
    output data_out_2__6 ;
    output data_out_2__5 ;
    output data_out_2__4 ;
    output data_out_2__3 ;
    output data_out_2__2 ;
    output data_out_2__1 ;
    output data_out_2__0 ;
    output data_out_1__7 ;
    output data_out_1__6 ;
    output data_out_1__5 ;
    output data_out_1__4 ;
    output data_out_1__3 ;
    output data_out_1__2 ;
    output data_out_1__1 ;
    output data_out_1__0 ;
    output data_out_0__7 ;
    output data_out_0__6 ;
    output data_out_0__5 ;
    output data_out_0__4 ;
    output data_out_0__3 ;
    output data_out_0__2 ;
    output data_out_0__1 ;
    output data_out_0__0 ;
     
	// TODO check this constant (the size of the ram)
    reg [7:0] ram_data [0:262143];
     
    initial begin
    	$readmemh("memory.list", ram_data);
    end
     
    assign { data_out_4__7, data_out_4__6, data_out_4__5, data_out_4__4, data_out_4__3, data_out_4__2, data_out_4__1, data_out_4__0} = ram_data[address_in + 4];
    
    assign { data_out_3__7, data_out_3__6, data_out_3__5, data_out_3__4, data_out_3__3, data_out_3__2, data_out_3__1, data_out_3__0} = ram_data[address_in + 3];

    assign { data_out_2__7, data_out_2__6, data_out_2__5, data_out_2__4, data_out_2__3, data_out_2__2, data_out_2__1, data_out_2__0} = ram_data[address_in + 2];

    assign { data_out_1__7, data_out_1__6, data_out_1__5, data_out_1__4, data_out_1__3, data_out_1__2, data_out_1__1, data_out_1__0} = ram_data[address_in + 1];

    assign { data_out_0__7, data_out_0__6, data_out_0__5, data_out_0__4, data_out_0__3, data_out_0__2, data_out_0__1, data_out_0__0} = ram_data[address_in];

    always @(clk_c or read_write_in or enable_in) begin
      if (!clk_c && !read_write_in && enable_in)
        ram_data[address_in] = data_in;
        $writememh("memory_out.list", ram_data);
    end

endmodule
