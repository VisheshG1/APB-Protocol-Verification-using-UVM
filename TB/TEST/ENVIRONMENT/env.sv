`include "uvm_macros.svh"
import uvm_pkg ::*;

class env extends uvm_env;
  
  `uvm_component_utils(env)
  
  agent agt;
  scoreboard sco;
  cvrg_col cov;
  
  function new ( string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    agt = agent :: type_id :: create("agt",this);
    sco = scoreboard :: type_id :: create("sco",this);
    cov = cvrg_col :: type_id :: create("cov",this);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);
    agt.drv_ap.connect(sco.drv2sco);
    agt.mon_ap.connect(sco.mon2sco);
    agt.mon_ap.connect(cov.analysis_export);
    
  endfunction
  
endclass
    
    
