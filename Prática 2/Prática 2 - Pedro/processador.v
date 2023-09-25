// Tarefas
// 1 - Checar como é feita a atribuição de DIN para IR

module processador (DIN, Resetn, Clock, Run, Done, ADDR, DOUT, W);
	
input [15:0] DIN;
input Resetn, Clock, Run;

output reg Done;
output [15:0] ADDR, DOUT;
output W;
	
// Sinais de Controle
reg IRin, Ain, Gin; // Sinais de controle de escrita nos registradores IR, A e G	
reg [9:0] Select;   // Sinais de controle de seleção do mux -> Select[7:0]=Rout, Select[8]=Gout, Select[9]=DINout
reg [7:0] Rin;		  // Sinais de controle de escrita nos registradores R0 a R7
reg [2:0] AluOp;	  // Sinal de controle que define a operação na ULA
reg AddrIn, DoutIn; // Sinais de controle relacionados aos registradores ADDR e DOUT
reg IncrPc, W_D;	  // Sinais de controle relacionados ao incremento do PC e ao registrador W_D
	
// Demais conexões
wire [3:0] I;				// Opcode da instrução
wire [7:0] Xreg, Yreg; 	// Sinal decodificado dos operandos RX e RY
wire [2:0] Tstep_Q;		// Sinal com o Time Step -> Guarda em qual passo o procesador está			
wire [15:0] A, G, ALU_out;							
wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7; // R7 -> PC
wire [15:0] BusWires, IR;
wire Clear = Done | ~Resetn;

// Instanciando o Multiplexador
MuxReg MuxReg(Select, DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, BusWires);

// Instanciando o Upcount
upcount Tstep (Clear, Clock, Tstep_Q);

// Instrução: IIIIXXXYYY
// [15:12] -> Instrução (11 Instruções no total)
// [11:9]  -> Registrador X
// [8:6]   -> Registrador Y

// Salvando o Opcode da instrução em I
assign I = IR[15:12];

// Decodificando o endereço dos registradores RX e RY
dec3to8 decX (IR[11:9], 1, Xreg); 
dec3to8 decY (IR[8:6], 1, Yreg);
	

always @(Tstep_Q or I or Xreg or Yreg) begin
	
	//Inicialização
	Select = 10'b0000000000;
	Done = 1'b0;
	IRin = 1'b0;
	Ain = 1'b0;	
	Gin = 1'b0;
	AluOp = 3'b000;
	Rin = 8'b00000000;
	AddrIn = 1'b0;
	DoutIn = 1'b0;
	IncrPc = 1'b0;
	W_D = 1'b0;		
		
		case (Tstep_Q)
		
			// Time Step 0 -> Salvar DIN em IR
			3'b000:
			begin
				IRin = 1'b1;
			end
				
			// Time Step 1
			3'b001:
			begin 
				IncrPc=Run;
				//Operação na memória
			end
			
			
				3'b010: // t2
				begin
					IRin=Run;						//Habilita escrita em IR
					Select[7:0]=8'b00000001;	//Seleciona R7 (PC)
					AddrIn = 1'b1;
				end
				3'b011: // t3
					case (I)
						4'b0000:								//mv = 0000
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Rin = Xreg;						//Seleciona o registrador para ser escrito
							Done = 1'b1;
						end
						4'b0001:								// mvi = 0001
						begin
							//Operação na memória
						end
						4'b0010,								// add = 0010
						4'b0011,								// sub = 0011
						4'b0100,								// and = 0100
						4'b0101,								// slt = 0101
						4'b0110,								// sll = 0110
						4'b0111:								// srl = 0111	
						begin
							Select[7:0] = Xreg;			//Rout = Xreg
							Ain = 1'b1;						// Habilita escrita em A
						end
						4'b1000,								// ld = 1000
						4'b1001:								// st = 1001
						begin
							Select[7:0] = Yreg;
							AddrIn = 1'b1;
						end
						4'b1010:								//mvnz = 1010
						begin
							if(G != 0) begin
								Select[7:0] = Yreg;
								Rin = Xreg;
								
								
							end
							Done = 1'b	1;
						end
					endcase
				3'b100: // t4
					case (I)	
						4'b0001:                      
						begin
							Select[9] = 1'b1;				//DINout = 1
							IncrPc=1'b1;
							Rin = Xreg;						//Seleciona o registrador para ser escrito
							Done = 1'b1;
						end
						4'b0010:								// add = 0010
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Gin = 1'b1;						// Habilita escrita em G
						end
						4'b0011:								// sub = 0011
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Gin = 1'b1;						// Habilita escrita em G
							AluOp = 3'b001;
						end
						4'b0100:								// and = 0100
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Gin = 1'b1;						// Habilita escrita em G
							AluOp = 3'b010;
						end
						4'b0101:								// slt = 0101
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Gin = 1'b1;						// Habilita escrita em G
							AluOp = 3'b011;
						end
						4'b0110:								// sll = 0110
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Gin = 1'b1;						// Habilita escrita em G
							AluOp = 3'b100;
						end
						4'b0111:								// srl = 0111
						begin
							Select[7:0] = Yreg;			//Rout = Yreg
							Gin = 1'b1;						// Habilita escrita em G
							AluOp = 3'b101;
						end					
						
						4'b1001:								// st = 1001
						begin	
							Select[7:0] = Xreg;
							DoutIn = 1'b1;
							W_D = 1'b1;
						end
					endcase
				3'b101: // t5
					case (I)
						4'b0010,								// add = 0010		
						4'b0011,								// sub = 0011
						4'b0100,								// and = 0100
						4'b0101,								// slt = 0101
						4'b0110,								// sll = 0110
						4'b0111:								// srl = 0111
						begin
							Select[8] = 1'b1;				// Gout = 1;
							Select[7:0] = 8'b00000000;	// Rout = 0;
							Rin = Xreg;
							Done = 1'b1;
						end
						4'b1000:								// ld = 1000
						begin
							Select[7:0] = 8'b00000000;
							Select[9] = 1'b1;
							Rin = Xreg;
							Done = 1'b1;
						end
						4'b1001:								// st = 1001
						begin
							Done = 1'b1;
						end
					endcase
			endcase
		
	end
	
	// Registradores 
	regn reg_0 (BusWires, Rin[7], Clock, R0);
	regn reg_1 (BusWires, Rin[6], Clock, R1);
	regn reg_2 (BusWires, Rin[5], Clock, R2);
	regn reg_3 (BusWires, Rin[4], Clock, R3);
	regn reg_4 (BusWires, Rin[3], Clock, R4);
	regn reg_5 (BusWires, Rin[2], Clock, R5);
	regn reg_6 (BusWires, Rin[1], Clock, R6);
	
	regn_pc reg_7 (BusWires, Rin[0], Clock, R7, IncrPc);
	
	regn reg_A (BusWires, Ain, Clock, A);
	regn reg_G (ALU_out, Gin, Clock, G);
	regn reg_IR (DIN, IRin, Clock, IR);
	
	regn reg_addr (BusWires, AddrIn, Clock, ADDR);
	regn reg_dout (BusWires, DoutIn, Clock, DOUT);
	regn reg_W (W_D, 1'b1, Clock, W);
	
		
	
	//ULA
	ALUn alun(AluOp, A, BusWires, ALU_out);

	
endmodule
