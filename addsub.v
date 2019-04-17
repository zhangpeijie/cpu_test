//Name: AddSub
//Function: 
//	 	AddSub = 0 Add
//      AddSub = 1 Sub
//Author: caojian

module addsub(AddSub, A, BusWires, Sum);
input AddSub;
input[15:0] A, BusWires;
output[15:0] Sum;
reg[15:0] Sum;

always@(AddSub or A or BusWires)
begin
	if(!AddSub)
	Sum = A + BusWires;
	else
	Sum = A - BusWires;
end

endmodule
