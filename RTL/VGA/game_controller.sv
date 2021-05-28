
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input logic playerDR,
			input	logic	missileDR,
			input	logic	aliensDR,
			input logic bombDR,
			input logic shipDR,
			input logic shieldsDR,
			input logic kavDR,
			
			output logic collision_aliens_missile,
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic collision_bomb_player,
			output logic collision_ship_missile,
			output logic collision_shields_missile,
			output logic collision_shields_bomb,
			output logic gameover
);

// drawing_request_Ball   -->  smiley
// drawing_request_1      -->  brackets
// drawing_request_2      -->  number/box 


//assign collision = ( drawing_request_Ball &&  drawing_request_1);// any collision 

						
// add colision between number and Smiley;
assign collision_aliens_missile = (missileDR && aliensDR);
assign collision_bomb_player = (playerDR && bombDR);
assign collision_ship_missile = (shipDR && missileDR);
assign collision_shields_missile = (shieldsDR && missileDR);
assign collision_shields_bomb = (shieldsDR && bombDR);
assign gameover = (aliensDR && kavDR);

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
				
//		change the section below  to collision between number and smiley


			if ((collision_aliens_missile || collision_bomb_player || collision_ship_missile || collision_shields_missile || collision_shields_bomb || gameover) && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ;
			end ;

	end 
end

endmodule
