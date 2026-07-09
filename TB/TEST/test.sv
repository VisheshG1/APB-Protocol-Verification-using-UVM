`include "uvm_macros.svh"
import uvm_pkg ::*;

class test extends uvm_test;
  
  `uvm_component_utils(test);
  
  env apb_env;
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    apb_env = env :: type_id :: create ("apb_env",this);
    
  endfunction
  
  virtual task run_phase ( uvm_phase phase);
    
    reset_seq rseq;
    seq_slave1_write sw1;
    seq_slave1_read sr1;
    seq_slave2_write sw2;
    seq_slave2_read sr2;
    
    phase.raise_objection(this);
    
    rseq = reset_seq :: type_id :: create("rseq");
    sw1 = seq_slave1_write :: type_id :: create("sw1");
    sr1 = seq_slave1_read :: type_id :: create("sr1");
    sw2 = seq_slave2_write :: type_id :: create("sw2");
    sr2 = seq_slave2_read :: type_id :: create("sr2");
    
    rseq.start(apb_env.agt.seqr);
    sw1.start(apb_env.agt.seqr);
    sr1.start(apb_env.agt.seqr);
    sw2.start(apb_env.agt.seqr);
    sr2.start(apb_env.agt.seqr);
    //#100;
    phase.drop_objection(this);
    
  endtask
  
endclass
