



module uart_test(input clk_50M, input rst_n, output tx, input rx,
output [7:0] status,
output [7:0] rec,
 output ledA,output ledS,output ledD,output ledW, output uart_clk);



parameter initialize=3'b0, start=3'b1, glow=3'd2;
reg [2:0] state=initialize;

parameter A = 14'd65, W=14'd87, S=14'd83, D=14'd68;


reg [13:0] rec_temp=14'd0;
reg [7:0] counter=8'd0;
reg [13:0] clk_div=14'd0;
reg ledw=1'b0;
reg leda=1'b0;
reg leds=1'b0;
reg ledd=1'b0;
reg [7:0] store=8'd0;

assign status=state;
assign rec=rec_temp;

always@(posedge clk_50M,negedge rst_n)
     begin
			if (!rst_n)
				clk_div <= 14'd0;
			else	
				
				if (clk_div < 14'd2604)
					clk_div = clk_div + 14'd1;
				else
					 clk_div = 14'd0;
     end

assign uart_clk = (clk_div < 14'd1302)? 1'b0:1'b1;


always@(negedge uart_clk)begin
	case(state)
	
	initialize  : begin
						if(!rx)begin
							state = start;
						end
						
						else begin
						state=initialize;
						end
						
					  end
						
	start:		begin
						if(counter==8'd8)begin
						state=glow;
						counter=8'd0;
						end
						
						else begin
						store[counter]=rx;
						rec_temp={rec_temp[13:0], rx};
						counter=counter+1;
						state=start;
						end
						
					end
					
	glow : begin
				
				if(store!=8'd0 && rx)
				state=initialize;
				end
	endcase
end

always@(posedge  clk_50M)begin
	case(store)
	
			A: begin
					 leda=1'b1;
					 leds=1'b0;
					 ledw=1'b0;
					 ledd=1'b0;
				end
				
			S: begin
					 leda=1'b0;
					 leds=1'b1;
					 ledw=1'b0;
					 ledd=1'b0;
				end
				
			W: begin
					 leda=1'b0;
					 leds=1'b0;
					 ledw=1'b1;
					 ledd=1'b0;
				end
				
			D: begin
					 leda=1'b0;
					 leds=1'b0;
					 ledw=1'b0;
					 ledd=1'b1;
				end
	
	endcase
end

assign ledA=leda;
assign ledS=leds;
assign ledD=ledd;
assign ledW=ledw;

uart uart_obj(.rst_n(rst_n), .clk_50M(clk_50M), .in_data(8'h4D), .tx(tx_temp));

assign tx=tx_temp;

endmodule

