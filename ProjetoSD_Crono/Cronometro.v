module main(clock, funcao, reset, parar, pausar, contar, saida0, saida1, saida2, saida3);
	
	input clock;
	input funcao;
	input reset;
	input parar;
	input pausar;
	input contar;
	
	output [3:0] saida0;
	output [3:0] saida1;
	output [3:0] saida2;
	output [3:0] saida3;
	
	reg [3:0]estado;
	
   parameter ZERADO = 4'b0000, CONTANDO = 4'b0001, PAUSADO = 4'b0010, PARADO = 4'b0011;
	
	always@(posedge clock) begin
		
		case(estado)     
            //se estiver no estagio de ZERADO
            ZERADO: begin
            
                
                
            end
           
            //se estiver no estágio de PAUSADO
            PAUSADO:begin
              
                
            end
           
            //se estiver no estado de CONTANDO
            CONTANDO:begin
               

            end
           
            //se estiver PARADO
            PARADO:begin
                       
               
            end
           
        endcase

		
	end
	
	
	
	
	
	
	
	
	
endmodule
	