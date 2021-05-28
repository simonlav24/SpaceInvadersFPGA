
module scoreBoard	(	
					input		logic	clk,
					input		logic	resetN,
					
					input logic collision_aliens_missile,
					input logic collision_ship_missile,
					input logic startOfFrame,
					
					output logic [3:0] digit0,
					output logic [3:0] digit1,
					output logic [3:0] digit2,
					output logic [3:0] digit3,
					output logic [3:0] digit4
);


logic [3:0] score0 = 4'b0000;
logic [3:0] score1 = 4'b0000;
logic [3:0] score2 = 4'b0000;
logic [3:0] score3 = 4'b0000;
logic [3:0] score4 = 4'b0000;

assign digit0 = score0;
assign digit1 = score1;
assign digit2 = score2;
assign digit3 = score3;
assign digit4 = score4;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		score0 <= 4'b0000;
		score1 <= 4'b0000;
		score2 <= 4'b0000;
		score3 <= 4'b0000;
		score4 <= 4'b0000;
	end
	
	else begin
		
		if(collision_aliens_missile == 1'b1) begin
			score1 <= score1 + 4'b0001;
		end
		if (collision_ship_missile == 1'b1) begin
			score2 <= score2 + 4'b0001;
		end
		
		if(score1 == 4'b1010) begin
			score2 <= score2 + 4'b0001;
			score1 <= 4'b0000;
		end
		if(score2 == 4'b1010) begin
			score3 <= score3 + 4'b0001;
			score2 <= 4'b0000;
		end
		if(score3 == 4'b1010) begin
			score4 <= score4 + 4'b0001;
			score3 <= 4'b0000;
		end

	end 
end




endmodule