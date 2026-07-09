`include "uvm_macros.svh"
//`include "uvm_packet.sv"
import uvm_pkg::*;

class driver extends uvm_driver #(packet);
  
  `uvm_component_utils(driver);
  virtual apb_if aif;
  packet pkt;
  uvm_analysis_port #(packet) drv;
  
  function new(string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    drv = new("drv",this);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","aif",aif))
      `uvm_warning("DRV","Cannot get interface");
      
  endfunction
    
    
  virtual task run_phase(uvm_phase phase);
    
    forever 
      begin
        
        seq_item_port.get_next_item(pkt);
        drive_transaction(pkt);
        seq_item_port.item_done();
        
      end 
  endtask
  
  
  virtual task drive_transaction ( packet pkt );
    
    @(posedge aif.pclk);
    if(pkt.presetn) 
      begin
           
   		 aif.psel    = 0;
         aif.penable = 0;  
         @(posedge aif.pclk)
         aif.psel = pkt.psel;     
   		 aif.pwrite  = pkt.pwrite;
   		 aif.padr    = pkt.padr;
   		 aif.pwdata  = pkt.pwdata;
        //aif.presetn = pkt.presetn;
   		 @(posedge aif.pclk);
       
        aif.penable = pkt.penable;
        
        `uvm_info("Driver",$sformatf("DATA SENT : Psel : %0d, Pwrite : %0d, Penable : %0d, Padr : %0d, Pwdata : %0d", pkt.psel,pkt.pwrite,pkt.penable,pkt.padr,pkt.pwdata),UVM_NONE);
      
    
    
    if(pkt.pwrite)
      begin
        drv.write(pkt); 
      end
        @(posedge aif.pclk);
      //end
    
   
   // @(posedge aif.pclk);
   while(!aif.pready) @(posedge aif.pclk);
    @(posedge aif.pclk);
        
    end
     aif.presetn <= pkt.presetn;
    //@(posedge aif.pclk);
        
    
  endtask
  
endclass
    
    
  
  
