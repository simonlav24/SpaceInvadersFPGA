// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	missile_object	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,  //collision if smiley hits an object
					input logic collision_ship,
					input	logic	[3:0] HitEdgeCode, //one bit per edge
					input logic shotPress,
					input logic [10:0] playerPosX,

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside
					output	 logic activeCheck					
);


// a module used to generate the  ball trajectory.  

int INITIAL_X = 320;
int INITIAL_Y = 420;
int INITIAL_X_SPEED = 0;
int INITIAL_Y_SPEED = -280;
int yAcc = 1;

int counter = 0;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;

logic active = 1'b0;



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		active <= 1'b0;
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		counter <= 0;
	end
	else begin
		// gameplay
		
		// if press shot and inactive
		if (shotPress == 1'b1 && active == 1'b0) begin
			topLeftX_FixedPoint <= (((playerPosX  & 11'h7fc ) + 32) * FIXED_POINT_MULTIPLIER);
			topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
			active <= 1'b1;
		end
		
		// if collision and active
		if ((collision == 1'b1 || collision_ship == 1'b1) && active == 1'b1) begin
			active <= 1'b0;
		end
			
		
		if (topLeftY_FixedPoint <= 0 && active == 1'b1) begin
			active <= 1'b0;
		end
		
		// physics
		if (startOfFrame == 1'b1 && active == 1'b1)
			topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;


	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    
assign	activeCheck = active;

endmodule
