module dump();
	initial begin
		$dumpfile ("stack.vcd");
		$dumpvars (0, tb);
		#1;
	end
endmodule
