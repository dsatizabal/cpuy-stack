module dump();
	initial begin
		$dumpfile ("stack.vcd");
		$dumpvars (0, stack);
		#1;
	end
endmodule
