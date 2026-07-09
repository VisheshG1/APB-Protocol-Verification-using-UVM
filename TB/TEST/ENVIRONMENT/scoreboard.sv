`include "uvm_macros.svh"
import uvm_pkg ::*;

`uvm_analysis_imp_decl (_drv)
`uvm_analysis_imp_decl (_mon)

class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils (scoreboard)
  
  uvm_analysis_imp_drv #(packet,scoreboard) drv2sco;
  uvm_analysis_imp_mon #(packet,scoreboard) mon2sco;
  
  bit [31:0] data_reg_1;
  bit [31:0] data_reg_2;
  bit [31:0] data_reg_3;
  bit [31:0] data_reg_4;
  bit error;
  
  bit [31 : 0] mem [31]; 

  
  function new(string path = "scoreboard", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase ( uvm_phase phase );
    
    super.build_phase(phase);
    drv2sco = new("drv2sco",this);
    mon2sco = new("mon2sco",this);
   /// pkt = packet :: type_id :: create("pkt");
    
  endfunction
  
  virtual function void write_drv (packet pkt);
    
    if(pkt.presetn == 0 ) begin
      
      {data_reg_1,data_reg_2,data_reg_3,data_reg_4} = 0;
      
      for(integer i=0;i<$size(mem);i=i+1)
        mem[i] <= 32'd0;  
    end
    
    else
    begin
    
    if(pkt.psel[0])
      begin
        
        case(pkt.padr)
                                
          3'b000 : begin data_reg_1 = pkt.pwdata; error = 1'b0;   end
          3'b001 : begin data_reg_2 = pkt.pwdata; error = 1'b0;   end          
          3'b010 : begin data_reg_3 = pkt.pwdata; error = 1'b0;  end          
          3'b011 : begin data_reg_4 = pkt.pwdata; error = 1'b0;  end 
          
          default : error = 1'b1;
          
        endcase
      end
    
    else if (pkt.psel[1])
      
      begin
        
        if(pkt.padr < $size(mem)) begin 
          mem[pkt.padr] = pkt.pwdata;    
          error = 1'b0; end
        else error =1'b1;
      end
    end
  endfunction
  
virtual function void write_mon(packet pkt);
  
  if(!pkt.pwrite)
     
    begin
      if(pkt.psel[0])
      begin
        
        case(pkt.padr)
                                         
          3'b000 :
            begin
              
              if(pkt.prdata === data_reg_1)
                `uvm_info("Sco","Test passed yayy!!",UVM_NONE)
              else 
                `uvm_info("Sco",$sformatf("Test Failed : At Padr = %0d data is : %0d but shoud be : %0d",pkt.padr,pkt.prdata,data_reg_1),UVM_NONE)
            end
          
          3'b001 : 
            begin
              
              if(pkt.prdata === data_reg_2)
                `uvm_info("Sco","Test passed yayy!!",UVM_NONE)
              else 
                `uvm_info("Sco",$sformatf("Test Failed : At Padr = %0d data is : %0d but shoud be : %0d",pkt.padr,pkt.prdata,data_reg_2),UVM_NONE)
            end  
          
          3'b010 :
            
            begin
              if(pkt.prdata === data_reg_3)
                `uvm_info("Sco","Test passed yayy!!",UVM_NONE)
              else 
                `uvm_info("Sco",$sformatf("Test Failed : At Padr = %0d data is : %0d but shoud be : %0d",pkt.padr,pkt.prdata,data_reg_3),UVM_NONE)
            end          
          
          3'b011 : begin
            if(pkt.prdata === data_reg_4)
                `uvm_info("Sco","Test passed yayy!!",UVM_NONE)
              else 
                `uvm_info("Sco",$sformatf("Test Failed : At Padr = %0d data is : %0d but shoud be : %0d",pkt.padr,pkt.prdata,data_reg_4),UVM_NONE)
            end   
                           
                           
          default :
            begin
              error = 1;
              if(error === pkt.pslverr)begin
                `uvm_info("Sco","Test passed yayy at pslverr!!",UVM_NONE)
                
              end
              else begin
             `uvm_info("Sco",$sformatf("Test Faild At error Exp : %0d REC : %0d",error,pkt.pslverr),UVM_NONE)
                 end
            end
                                                                       
        endcase
        
      end
    
    else if ( pkt.psel[1])
      begin
    
        
        if(pkt.padr < $size(mem))
        begin
          if(pkt.prdata === mem[pkt.padr])
            `uvm_info("Sco","Test Passed ",UVM_NONE)
          else 
            `uvm_info("Sco",$sformatf("Test Faild At Padr of mem : %0d Exp : %0d REC : %0d",pkt.padr,mem[pkt.padr],pkt.prdata),UVM_NONE)
        end
    else
       begin
         error = 1;
         if(error === pkt.pslverr)
           begin
             `uvm_info("Sco","Test Passed yayy at pslverr!",UVM_NONE)
           end
         else
           begin
             `uvm_info("Sco",$sformatf("Test Faild At error Exp : %0d REC : %0d",error,pkt.pslverr),UVM_NONE)
           end
       end
           end
      end
              
              else
                begin 
                  
                  if(pkt.psel[0])
                  begin
                    
                    if(pkt.padr > 3)
                      begin
                        
                          begin
                          // error = 1;
                           if(error === pkt.pslverr)begin
                             `uvm_info("Sco","Test passed yayy for pslverr!!",UVM_NONE)
                             end
                           else begin
                          `uvm_info("Sco",$sformatf("Test Faild At error Exp : %0d REC : %0d",error,pkt.pslverr),UVM_NONE)
                              end
                         end
                      end
                    
                  end
                  else if(pkt.psel[1])
                begin
                  
                  if (pkt.padr >= $size(mem))
                    begin
                     // error = 1;
                      if(error === pkt.pslverr)
                        begin
                          `uvm_info("Sco","Test Passed yayy at pslveer!",UVM_NONE)
                        end
                      else
                        begin
                          `uvm_info("Sco",$sformatf("Test Faild At error Exp : %0d REC : %0d",error,pkt.pslverr),UVM_NONE)
                        end
                    end
                end
                end 
                     
           
  endfunction
  
endclass
        
        
        
    
    
                                      
                                      
                          
