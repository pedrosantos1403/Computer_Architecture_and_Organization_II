// Módulo não está sendo utilizado

module Mux2to1(Select,A,B,Out);

input [15:0]A,B;
input Select;
 
output [15:0]Out;
reg [15:0]Out;
 
always@(Select or A or B)
 begin
  case (Select)
	  1'b1:Out = A;
	  default:Out = B;
  endcase
end
 
endmodule