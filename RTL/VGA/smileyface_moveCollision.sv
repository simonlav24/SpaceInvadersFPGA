// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	smileyface_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,  //collision if smiley hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge
					input logic rightPress,
					input logic leftPress,

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 320;
parameter int INITIAL_Y = 300;
parameter int INITIAL_X_SPEED = 0;
//parameter int INITIAL_Y_SPEED = 20;
//parameter int MAX_Y_SPEED = 230;
//const int  Y_ACCEL = -1;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;
const int   x_speed = 120;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity or  colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= 0;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	else begin
		
		
				//topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; // position interpolation 
				
				//if (Yspeed < MAX_Y_SPEED )//  limit the spped while going down 
				//		Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 
		
								
				//if (Y_direction) begin // button was pushed to go upwards 
						//if (Yspeed > 0 ) //  while moving right
								//Yspeed <= -Yspeed  ;  // chjange spped to go up 
				//end ; 
			

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
		
			if (rightPress == 1'b1 && topLeftX_FixedPoint + OBJECT_WIDTH_X * FIXED_POINT_MULTIPLIER < 630 * FIXED_POINT_MULTIPLIER)
				Xspeed <= x_speed;
			else if (leftPress == 1'b1 && topLeftX_FixedPoint > 10 * FIXED_POINT_MULTIPLIER)
				Xspeed <= -x_speed;
			else
				Xspeed <= 0;
	
		topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
