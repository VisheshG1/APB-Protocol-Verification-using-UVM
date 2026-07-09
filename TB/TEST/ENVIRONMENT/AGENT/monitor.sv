`include "uvm_macros.svh"
import uvm_pkg ::*;

class monitor extends uvm_monitor ;
  
  `uvm_component_utils(monitor)
  uvm_analysis_port #(packet) mon;
  packet pkt;
  virtual apb_if aif;
  
  function new ( string path = "monitor", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = new("mon",this);
    
    if(!uvm_config_db #(virtual apb_if) :: get(this,"","aif",aif))
      `uvm_warning("MON","MON Config is sucked");
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    forever 
      begin
        
        pkt = packet :: type_id :: create ("pkt");

        //@(posedge aif.pclk);
        @(posedge aif.pclk);
        while(!((|aif.psel) && aif.penable)) @(posedge aif.pclk);
        @(posedge aif.pclk);

      while(!aif.pready) @(posedge aif.pclk);

        @(posedge aif.pclk);
   
        pkt.pslverr = aif.pslverr;
        if(!aif.pwrite) pkt.prdata = aif.prdata;
        
        pkt.psel = aif.psel;
        pkt.pwrite = aif.pwrite;
        pkt.penable = aif.penable;
        pkt.padr = aif.padr;
        pkt.pwdata = aif.pwdata;
        
        `uvm_info("Monitor",$sformatf("DATA SENT : Psel : %0d, Pwrite : %0d, Penable : %0d, Padr : %0d, Prdata : %0d, Pwdata : %0d", aif.psel,aif.pwrite,aif.penable,aif.padr,aif.prdata,aif.pwdata),UVM_NONE);

        mon.write(pkt);
      end
  endtask
endclass
        
      
    
