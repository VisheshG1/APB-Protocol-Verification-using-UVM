`include "uvm_macros.svh"
import uvm_pkg::*;

class sequencer extends uvm_sequencer #(packet);
  
  `uvm_component_utils(sequencer);
  
  function new(string path = "sequencer", uvm_component parent = null);
    super.new(path,parent);
  endfunction 
  
endclass

