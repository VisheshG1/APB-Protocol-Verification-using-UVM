`include "uvm_macros.svh"
import uvm_pkg::*;

class agent extends uvm_agent;
  
  `uvm_component_utils(agent)
  
  sequencer seqr;
  driver drv;
  monitor mon;
  
  uvm_analysis_port #(packet) drv_ap;
  uvm_analysis_port #(packet) mon_ap;
  
  function new(string path = "agent", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    drv = driver :: type_id :: create("drv",this);
    mon = monitor :: type_id :: create("mon",this);
    seqr = sequencer :: type_id :: create("seqr",this);
    //agt2sco = new("agt2sco",this);
    drv_ap = new("drv_ap", this);
    mon_ap = new("mon_ap", this);
    
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    drv.drv.connect(drv_ap);
    mon.mon.connect(mon_ap);
  endfunction
  
endclass
