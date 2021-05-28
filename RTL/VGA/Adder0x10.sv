

module	Adder0x10	(	
					input	logic	[10:0] param1,
					input logic [10:0] param2,
					
					output unsigned [10:0] sum
 ) ;
 
 assign sum = param1 + param2;
 
 endmodule
 