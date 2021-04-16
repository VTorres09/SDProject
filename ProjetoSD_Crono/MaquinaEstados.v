
module MaquinaEstados(reset, conta, pausa, para, clock, clock_botao,
CountDs, CountSeg0, CountSeg1, CountSeg2);

//Definindo inputs e outputs
input reset;
input conta;
input pausa;
input para;
input clock;
input clock_botao;

reg reset_old;
reg reset_raise;
reg conta_old;
reg conta_raise;
reg pausa_old;
reg pausa_raise;
reg para_old;
reg para_raise;

output reg [3:0] CountDs;
output reg [3:0] CountSeg0;
output reg [3:0] CountSeg1;
output reg [3:0] CountSeg2;

reg [1:0] estado_atual; 
reg [3:0] CountSeg0Aux;
reg [3:0] CountSeg1Aux;
reg [3:0] CountSeg2Aux;
reg [3:0] CountDsAux;
reg PararCount;
reg ZerarCount;
reg MostrarCount;

//00 = reset, 01 = contar, 10 = pausar, 11 = parar
parameter resetar = 0, contar = 1, pausar = 2, parar = 3;

//inicialização
    initial begin
        estado_atual <= resetar;
        CountDs <= 4'd0;
		  CountSeg0 <= 4'd0;
		  CountSeg1 <= 4'd0;
		  CountSeg2 <= 4'd0;
		  CountDsAux <= 4'd0;
		  CountSeg0Aux <= 4'd0;
		  CountSeg1Aux <= 4'd0;
		  CountSeg2Aux <= 4'd0;
		  PararCount <= 1'd1;
        ZerarCount <= 1'd0;
        MostrarCount <= 1'd1;
		  reset_old <= 1'b1;
		  reset_raise <= 1'b0;
        conta_old <= 1'b1;
        conta_raise <= 1'b0;
        pausa_old <= 1'b1;
        pausa_raise <= 1'b0;
        para_old <= 1'b1;
        para_raise <= 1'b0;
    end

always @ (*) begin //parte combinacional cronometro
	case(estado_atual)
	resetar:begin
		ZerarCount <= 1'd1;
		PararCount <= 1'd1;
		MostrarCount <= 1'd1;	
		end
	contar:begin
		ZerarCount <= 1'd0;
		PararCount <= 1'd0;	
		MostrarCount <= 1'd1;
		end
	pausar:begin
		ZerarCount <= 1'd0;
		PararCount <= 1'd0;
		MostrarCount <=  1'd0;			
		end
	parar:begin
		ZerarCount <= 1'd0;
		PararCount <= 1'd1;
		MostrarCount <= 1'd1;
		end
	endcase
end



always @ (posedge clock_botao)begin//parte sequencial cronometro
	 
	 // detect rising edge
    if (conta_old != conta && conta == 1'b1)begin
          conta_raise <= 1'b1;
	 end
    conta_old <= conta;
	
	 if (reset_old != reset && reset == 1'b1)begin
          reset_raise <= 1'b1;
	 end
    reset_old <= reset;
	 
	 if (pausa_old != pausa && pausa == 1'b1)begin
          pausa_raise <= 1'b1;
	 end
    pausa_old <= pausa;
	 
	 if (para_old != para && para == 1'b1)begin
          para_raise <= 1'b1;
	 end
    para_old <= para;
	 

	if(reset_raise == 1'b1)begin
		estado_atual <= resetar;
		reset_raise <= 1'b0;
	end
	else if(conta_raise == 1'b1)begin
		estado_atual <= contar;
		conta_raise <= 1'b0;
	end
	else if((pausa_raise == 1'b1) && (estado_atual == pausar))begin
		estado_atual <= contar;	
		pausa_raise <= 1'b0;
	end
	else if((pausa_raise  == 1'b1) && (estado_atual != pausar))begin
		estado_atual <= pausar;
		pausa_raise <= 1'b0;
	end
	else if(para_raise  == 1'b1)begin
		if(estado_atual == contar)begin
			estado_atual <= parar;		
		end	
		para_raise <= 1'b0;
	end

end



//contador
always@(negedge clock) begin
	
	if(ZerarCount) begin
		CountDsAux <= 4'd0;
		CountSeg0Aux <= 4'd0;
		CountSeg1Aux <= 4'd0;
		CountSeg2Aux <= 4'd0;
	end
	else begin
		if(!PararCount)begin
			if(CountDsAux != 4'd9)begin
				CountDsAux <= CountDsAux + 4'd1;
			end
			else begin
				CountDsAux <= 4'd0;
				if(CountSeg0Aux != 4'd9)begin
					CountSeg0Aux <= CountSeg0Aux + 4'd1;
				end
				else begin
					CountSeg0Aux <= 4'd0;
					if(CountSeg1Aux != 4'd9)begin
						CountSeg1Aux <= CountSeg1Aux + 4'd1;
					end
					else begin
						CountSeg1Aux <= 4'd0;
						if(CountSeg2Aux != 4'd9)begin
							CountSeg2Aux <= CountSeg2Aux + 4'd1;
						end
						else begin
							CountDsAux <= 4'd0;
							CountSeg0Aux <= 4'd0;
							CountSeg1Aux <= 4'd0;
							CountSeg2Aux <= 4'd0;
						end		
					end
				end
			end
		end
	end
	
	
		if(MostrarCount)begin
			CountDs <= CountDsAux;
			CountSeg0 <= CountSeg0Aux;
			CountSeg1 <= CountSeg1Aux;
			CountSeg2 <= CountSeg2Aux;
					
		end

 end
 

endmodule