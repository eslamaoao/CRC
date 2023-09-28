module CRC 
(
input wire  DATA,
input wire ACTIVE,
input wire CLK,
input wire RST,
output reg CRC,
output reg Valid

);

reg [7:0] LFSR;
reg [3:0] count;
wire feed_back;
reg tmp ;
wire ok;

assign feed_back = LFSR[0] ^ DATA;

always@(posedge CLK or negedge RST )
 begin
	if(!RST)
		begin
			LFSR   <=  8'hD8;
			Valid  <=  1'b0;
			CRC    <=  1'b0;
		end
	else if (ACTIVE)
		begin
			LFSR[7] <= feed_back;
			LFSR[6] <= feed_back ^ LFSR[7];
			LFSR[5] <= LFSR[6];
			LFSR[4] <= LFSR[5];
			LFSR[3] <= LFSR[4];
			LFSR[2] <= LFSR[3] ^ feed_back ;
			LFSR[1] <= LFSR[2];
			LFSR[0] <= LFSR[1];
			Valid  <= 1'b0;

		end	
			
	else if(ok)
			begin
				Valid  <= 1'b1;
				CRC    <= LFSR[0] ;
				LFSR[0]<= LFSR[1] ;
				LFSR[1]<= LFSR[2] ;
				LFSR[2]<= LFSR[3] ;
				LFSR[3]<= LFSR[4] ;
				LFSR[4]<= LFSR[5] ;
				LFSR[5]<= LFSR[6] ;
				LFSR[6]<= LFSR[7] ;
				LFSR[7] <= 1'b0 ;
			end
		else
			begin
				CRC    <= 1'b0;
				Valid  <= 1'b0;
			end
				
end		
 assign ok = (!( count == 5'b1000 ) && ( !(ACTIVE)) && (tmp)); 
/*
always@(*)
 begin
	if ((!ACTIVE) && (tmp) &&(!(count==5'b1001)))
		ok <= 1'b1;
	else
		ok <= 1'b0;
 end
*/
always@(posedge CLK or negedge RST)
 begin
 if(!RST)
	count  <= 5'b1000;
 else if (ACTIVE)
  begin			
	tmp <= 1'b1;
	count <= 5'b0;
  end
 else if(!(count==5'b1000))	
		begin
			count <= count + 5'b1;
		end
 else
		begin
				count <= 5'b1000;
				tmp <= 1'b0;
		end
end
endmodule
