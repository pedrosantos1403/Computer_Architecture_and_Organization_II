module MuxReg(Select, DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, BusWires);
 
input [9:0] Select;
input [15:0] DIN,R0,R1,R2,R3,R4,R5,R6,R7,G;

output reg [15:0]BusWires;
 
always @(Select or DIN or R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7 or G)
begin
  case (Select)
	  // Baseado no sinal de Select é selecionado o local que será salvo os dados de DIN
	  10'b10_0000_0000:BusWires = DIN;
	  10'b01_0000_0000:BusWires = G;
	  10'b00_1000_0000:BusWires = R0;
	  10'b00_0100_0000:BusWires = R1;
	  10'b00_0010_0000:BusWires = R2;
	  10'b00_0001_0000:BusWires = R3;
	  10'b00_0000_1000:BusWires = R4;
	  10'b00_0000_0100:BusWires = R5;
	  10'b00_0000_0010:BusWires = R6;
	  10'b00_0000_0001:BusWires = R7;
	  default:BusWires = 16'h55AA;
  endcase
 end

endmodule