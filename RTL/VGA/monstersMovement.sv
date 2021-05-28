// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	monsterMovement(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	[3:0] HitEdgeCode, //one bit per edge
					
					
					
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY, // can be negative , if the object is partliy outside
					output    logic rise
					
					
);


// a module used to generate the  ball trajectory.  

int INITIAL_X = 33;
int INITIAL_Y = 32;
int INITIAL_X_SPEED = 15;
int INITIAL_Y_SPEED = 0;
int rise_int=0;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;

int mat_width = 320;
int spacing = 0;

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity or  colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	else begin
		
		if (startOfFrame == 1'b1) begin
			if (topLeftX_FixedPoint + (mat_width + spacing) * FIXED_POINT_MULTIPLIER > (640 - 32) * FIXED_POINT_MULTIPLIER) begin
				topLeftY_FixedPoint	<= topLeftY_FixedPoint + 32 * FIXED_POINT_MULTIPLIER;
			end
			
			if (topLeftX_FixedPoint < (32 - spacing) * FIXED_POINT_MULTIPLIER) begin
				topLeftY_FixedPoint	<= topLeftY_FixedPoint + 32 * FIXED_POINT_MULTIPLIER;
			end
			
		end
			
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	else begin
			// gameplay
		if (startOfFrame == 1'b1) begin
			
			
			
			if (topLeftX_FixedPoint + (mat_width + spacing) * FIXED_POINT_MULTIPLIER > (640 - 32) * FIXED_POINT_MULTIPLIER) begin
				Xspeed = - Xspeed - 5;
			end
			
			if (topLeftX_FixedPoint < (32 - spacing) * FIXED_POINT_MULTIPLIER) begin
				Xspeed = - Xspeed + 5;
			end
			
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		end
			
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    

endmodule
