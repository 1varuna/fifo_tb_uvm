module sv_dpi;

import "DPI-C" function void cpp_method();
import "DPI-C" function int factorial(int num);
initial begin
	$display("\tBefore calling C++ function\n");
	cpp_method();
	$display("\tAfter calling C++ function\n");
end

function void sv_method();
	$display("\t HELLO world from System Verilog!\n");
endfunction

endmodule
