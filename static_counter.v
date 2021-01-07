
module static_counter(enable);
parameter COUNTER_BIT_COUNT	= 16;
parameter STOP_COUNT_VALUE	= 32768;
input enable;

	reg[COUNTER_BIT_COUNT - 1 : 0] count;

	assign add_count = (enable);
	assign stop_count = add_count && count == (STOP_COUNT_VALUE) - 1;

	always @(posedge clk or negedge nrst)
	begin
		if(nrst == 0)
		begin
			count <= 0;
		end
		else if(add_time_cnt)
		begin
			if(stop_count)
				count <= 0;
		else
			count <= count + 1;
		end
	end

endmodule

