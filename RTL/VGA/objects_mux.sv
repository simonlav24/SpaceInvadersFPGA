
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					
		   // smiley 
					input		logic	smileyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] smileyRGB, 
					     
		  // add the box here 
					input		logic boxDrawingRequest,
					input		logic [7:0] boxRGB,
			  
			  
		  ////////////////////////
		  // background
					input    logic HartDrawingRequest, // box of numbers
					input		logic	[7:0] hartRGB,   
					input		logic	[7:0] backGroundRGB, 
					
		// missile
					input		logic	missileDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] missileRGB, 
			  
		// bomb
					input		logic	bombDrawingReq, // two set of inputs per unit
					input		logic	[7:0] bombRGB, 
					
					input    logic shipDrawingReq,
					input    logic [7:0] shipRGB,
					
					input    logic scoreDrawingReq,
					input    logic [7:0] scoreRGB,
			  
					input    logic shieldsDR,
					input 	logic [7:0] shieldsRGB,
					
					input		logic kavDR,
					input		logic [7:0] kavRGB,
					
					input 	logic gameover,
					
					input		logic screenDR,
					input		logic [7:0] screenRGB,
			  
				   output	logic	[7:0] RGBOut
);

int gameState = 0;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
			gameState <= 0;
	end
	
	else begin
			if (gameState == 0) begin
				if (missileDrawingRequest == 1'b1)
					RGBOut <= missileRGB;  //first priority 
				
				else if (scoreDrawingReq == 1'b1)
					RGBOut <= scoreRGB;
				
				else if (smileyDrawingRequest == 1'b1 )   
					RGBOut <= smileyRGB; 
			
				else if (shieldsDR == 1'b1)
					RGBOut <= shieldsRGB;
		 
				//else if (boxDrawingRequest == 1'b1)
				//	RGBOut <= boxRGB;
				
				else if (bombDrawingReq == 1'b1)
					RGBOut <= bombRGB;
						
				else if (shipDrawingReq == 1'b1)
					RGBOut <= shipRGB;
				
				else if (HartDrawingRequest == 1'b1)
					RGBOut <= hartRGB;
					
				//else if (kavDR == 1'b1)
				//	RGBOut <= kavRGB;
					
				else 
					RGBOut <= backGroundRGB ; // last priority
			end
			
			if (gameState == 1) begin
				if (screenDR)
					RGBOut <= screenRGB;
				
				else
					RGBOut <= backGroundRGB;
			end
			
			if(gameover == 1'b1) 
				gameState <= 1;
			
				
			
		end
	end

endmodule


