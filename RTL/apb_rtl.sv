// Code your design here
module APB_slave1 #(parameter length = 32,size = 8, idle = 0, setup =1, access =2) (
  
  input pclk,
  input presetn,
  
  input [$clog2(size)-1: 0] padr,
  input psel,
  input pwrite,
  input penable,
  
  input [length-1 :0] pwdata,
  output reg [length-1 :0] prdata,
  
  output reg pready,
  output reg pslverr
);
  
  reg [31:0] data_reg_1;
  reg [31:0] data_reg_2;
  reg [31:0] data_reg_3;
  reg [31:0] data_reg_4;
  
  reg [1:0]n_state,c_state;
  
  reg [2:0]wait_cycles =5;
  
  //assign pslverr = (padr > 3'011) ? 1'b0 : 1'b0;
  
  always @(posedge pclk or negedge presetn)
    begin
     
      if(presetn == 0) c_state <= idle;
      else c_state <= n_state;
      
    end
  
  always @(*)
    begin
      
      case (c_state)
        
        idle : 
          
          begin
            if(psel) n_state = setup;
            else n_state = idle;
          end
        
        setup :
          
          begin
            if(psel & !penable) n_state = setup;
            else if (psel & penable) n_state = access;
            else if (!psel) n_state = idle;
          end
        
        access :
          
          begin
            
            if(pready)
              begin
                
                if(psel & !penable) n_state = setup;
                else if (!psel) n_state = idle;
                else n_state = access;
              end
            
            else n_state = access;
          end
        
        default : n_state = c_state;
      endcase
    end
  
  
  always @(posedge pclk or negedge presetn)
    begin
      
      if(!presetn)
      
        begin
          data_reg_1 <= 0;
          data_reg_2 <= 0;
          data_reg_3 <= 0;
          data_reg_4 <= 0; 
        end
      
      else
        begin
          
          case(c_state)
            
            idle :
              
              begin  
                pready <= 0;
                pslverr <=0;
              end
            
            setup :
              
              begin
                pready <= 0;
                pslverr <= 0;
                wait_cycles <= 5;
                //repeat(wait_cycles) @(posedge pclk);
              end
            
            access :
              
              begin
               // repeat(wait_cycles) @(posedge pclk);
                if ( wait_cycles != 0 ) 
                  begin
                    wait_cycles <= wait_cycles -1 ;
                    pready <=0;
                  end
                
                else 
                  begin
                
                     pready <= 1;
                     prdata <= 0;
                     
                     if ( psel && penable && !pwrite )
                       begin
                       
                         case(padr)
                           
                           3'b000 : prdata <= data_reg_1;
                           3'b001 : prdata <= data_reg_2;
                           3'b010 : prdata <= data_reg_3;
                           3'b011 : prdata <= data_reg_4;
                           
                           default : pslverr <= 1;
                           
                         endcase
                       end
                
                     else if ( psel && penable && pwrite )
                       begin
                         
                         case(padr)
                           
                           3'b000 : data_reg_1 <= pwdata;
                           3'b001 : data_reg_2 <= pwdata;
                           3'b010 : data_reg_3 <= pwdata;
                           3'b011 : data_reg_4 <= pwdata;
                           default : pslverr <= 1;
                           
                         endcase
                       end
                end
              end
          endcase
        end
    end
endmodule
          
                  
module APB_slave2 #(parameter length = 32,size = 32, idle = 0, setup =1, access =2) (
  
  input pclk,
  input presetn,
  
  input [$clog2(size)-1: 0] padr,
  input psel,
  input pwrite,
  input penable,
  
  input [length-1 :0] pwdata,
  output reg [length-1 :0] prdata,
  
  output reg pready,
  output reg pslverr
);
  
  reg [length-1 : 0] mem [size-1];

  
  reg [1:0]n_state,c_state;
  reg [2:0]wait_cycles = 3;
  
  //assign pslverr = (padr > 3'011) ? 1'b0 : 1'b0;
  
  always @(posedge pclk or negedge presetn)
    begin
     
      if(presetn == 0) c_state <= idle;
      else c_state <= n_state;
      
    end
  
  always @(*)
    begin
      
      case (c_state)
        
        idle : 
          
          begin
            if(psel) n_state = setup;
            else n_state = idle;
          end
        
        setup :
          
          begin
            if(psel & !penable) n_state = setup;
            else if (psel & penable) n_state = access;
            else if (!psel) n_state = idle;
          end
        
        access :
          
          begin
            if(pready)
              begin
                
                if(psel & !penable) n_state = setup;
                else if (!psel) n_state = idle;
                else n_state = access;
              end
            
             else n_state = access;
          end
       
        
        default : n_state = c_state;
      endcase
    end
  
  
  always @(posedge pclk or negedge presetn)
    begin
      
      if(!presetn)
      
        begin
          
          for(integer i=0;i<$size(mem);i=i+1)
            mem[i] <= 32'd0;
          
        end
      
      else
        begin
          
          case(c_state)
            
            idle :
              
              begin  
                pready <= 0;
                pslverr <=0;
                prdata <= 0;
              end
            
            setup :
              
              begin
                pready <= 0;
                pslverr <= 0;
                wait_cycles <= 7;
              end
            
            access :
             begin 
               
              if ( wait_cycles != 0 ) 
                  begin
                    wait_cycles <= wait_cycles -1 ;
                    pready <=0;
                  end
            else
            
              begin
                pready <= 1;
                prdata <= 0;
                
                if ( psel && penable && !pwrite )
                  begin
                    
                    if(padr <= $size(mem)-1) prdata <= mem[padr];
                    else pslverr <=1;
                    
                  end
                
                else if ( psel && penable && pwrite )
                  begin
                    
                    if(padr <= $size(mem)-1) mem[padr] <= pwdata;
                    else pslverr <=1;
                    
                  end
                end
             end
          endcase
        end
       
    end
endmodule
            
  
