//Name: busmux
//Function: 
//	 	select which reg push to bus
//Author: caojian
module busmux(Rout, Gout, DINout, R0, R1, R2, R3, R4, R5, R6, R7, G, DIN, BusWires);
input[0:7]  Rout;
input Gout, DINout;
input[15:0] R0, R1, R2, R3, R4, R5, R6, R7, G, DIN;
output[15:0] BusWires;
reg[15:0] BusWires;
wire[1:10] Sel;
assign Sel = {Rout, Gout, DINout};
always@(*)
begin
	if(Sel == 10'b1000000000)
		BusWires = R0;
	else if(Sel == 10'b0100000000)
		BusWires = R1;
	else if(Sel == 10'b0010000000)
		BusWires = R2;
	else if(Sel == 10'b0001000000)
		BusWires = R3;
	else if(Sel == 10'b0000100000)
		BusWires = R4;
	else if(Sel == 10'b0000010000)
		BusWires = R5;
	else if(Sel == 10'b0000001000)
		BusWires = R6;
	else if(Sel == 10'b0000000100)
		BusWires = R7;		
	else if(Sel == 10'b0000000010)
		BusWires = G;
	else BusWires = DIN;
end
endmodule
