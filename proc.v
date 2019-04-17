//Name: proc
//Function: 
//	 	000: mv	    	Rx,Ry			: Rx <- [Ry]
//	 	001: mvi		Rx,#D			: Rx <- D
//	 	010: add		Rx, Ry			: Rx <- [Rx] + [Ry]
//	 	011: sub		Rx, Ry			: Rx <- [Rx] - [Ry]
//	 	OPCODE format: III XXX YYY, where 
//	 	III = instruction, XXX = Rx, and YYY = Ry. For mvi,
//	 	a second word of data is loaded from DIN
//      run = 1, cpu can run
//Author: caojian

module proc(DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output Done;
	output [15:0] BusWires;

	reg [0:7] Rin, Rout;
	reg IRin, Done, DINout, Ain, Gin, Gout, AddSub;
	wire [1:0] Tstep_Q;
	wire [2:0] I;
	wire [0:7] Xreg, Y;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G, BusWires, Sum;
	wire [1:9] IR;
	wire [1:10] Sel; // bus selector
	
	wire Clear = ~Resetn | Done | (~Run & ~Tstep_Q[1] & ~Tstep_Q[0]); // run=1, shield the Tstep, both Tstep_Q[1] and Tstep_Q[0]=0 means current instruction is finished.<run=1 cpu not stop until Tstep=0>
	
always@(Tstep_Q or Xreg or Y or I)
begin
	Done = 1'b0; Ain = 1'b0; Gin = 1'b0; Gout = 1'b0; AddSub = 1'b0; IRin = 1'b0; DINout =1'b0; Rin = 8'b0; Rout = 8'b0;
	
case(Tstep_Q)
2'b00:
	begin
	IRin = 1'b1;
	end
2'b01:
	begin
		case(I)
		3'b000://mv Rx, Ry
		begin
		Rout = Y;
		Rin = Xreg;
		Done = 1'b1;
		end
		3'b001://mvi Rx, #D
		begin
		DINout = 1'b1;
		Rin = Xreg;
		Done = 1'b1;
		end
		3'b010, 3'b011://add, sub
		begin
		Rout = Xreg;
		Ain = 1'b1;
		end
		default: ;
		endcase
	end
2'b10:
	begin
		case(I)
		3'b010://add
		begin
		Rout = Y;
		Gin = 1'b1;
		end
		3'b011://sub
		begin
		Rout = Y;
		AddSub = 1'b1;
		Gin = 1'b1;
		end
		default: ;
		endcase
	end
2'b11:
	begin
	case(I)
	3'b010, 3'b011://add
	begin
	Gout = 1'b1;
	Rin = Xreg;
	Done = 1'b1;
	end
	default: ;
	endcase
	end
endcase
end

//reg groups
regn reg_0(BusWires, Rin[0], Clock, R0);
regn reg_1(BusWires, Rin[1], Clock, R1);
regn reg_2(BusWires, Rin[2], Clock, R2);
regn reg_3(BusWires, Rin[3], Clock, R3);
regn reg_4(BusWires, Rin[4], Clock, R4);
regn reg_5(BusWires, Rin[5], Clock, R5);
regn reg_6(BusWires, Rin[6], Clock, R6);
regn reg_7(BusWires, Rin[7], Clock, R7);
regn reg_A(BusWires, Ain, Clock, A);
regn #(.n(9)) reg_IR(DIN[15:7], IRin, Clock, IR);
regn reg_G(Sum, Gin, Clock, G);

//AddSub
addsub addsub1(AddSub, A, BusWires, Sum);

//mux
busmux busmux1(Rout, Gout, DINout, R0, R1, R2, R3, R4, R5, R6, R7, G, DIN, BusWires);

//counter
upcount Tstep (Clear, Clock, Tstep_Q);

//dec3to8
assign I = IR[1:3];
dec3to8 decX (IR[4:6], 1'b1, Xreg);
dec3to8 decY (IR[7:9], 1'b1, Y);

endmodule
