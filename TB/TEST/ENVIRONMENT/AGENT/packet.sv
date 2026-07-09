`include "uvm_macros.svh"
import uvm_pkg::*;

class packet extends uvm_sequence_item;
  
  rand logic [4:0] padr;
  logic pwrite;
  rand  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic pslverr;
  logic pready;
  logic [1:0] psel;
 // logic psel1;
 // logic psel2;
  logic penable;
  logic presetn;
  
  
constraint slaves_adr{

  if(psel[0])
    padr inside {[5'h0 : 5'h4]};

  else if(psel[1])
      padr inside {[5'h0 : 5'h1F]};

}
 
  `uvm_object_utils_begin(packet)
  `uvm_field_int(padr,UVM_DEFAULT);
  `uvm_field_int(pslverr,UVM_DEFAULT);
  `uvm_field_int(pwrite,UVM_DEFAULT);
  `uvm_field_int(pwdata,UVM_DEFAULT);
  `uvm_field_int(prdata,UVM_DEFAULT);
  `uvm_field_int(pready,UVM_DEFAULT);
  //`uvm_field_int(psel1,UVM_DEFAULT);
 // `uvm_field_int(psel2,UVM_DEFAULT);
  `uvm_field_int(psel,UVM_DEFAULT);
  `uvm_object_utils_end
  
  function new(string path = "packet");
    super.new(path);
  endfunction 
  
endclass
