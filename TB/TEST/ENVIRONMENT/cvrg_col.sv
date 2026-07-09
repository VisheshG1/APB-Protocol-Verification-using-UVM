`include "uvm_macros.svh"
import uvm_pkg::*;

class cvrg_col extends uvm_subscriber #(packet);
  
  `uvm_component_utils(cvrg_col)
  packet pkt;
  
  covergroup slave_1;
    
    slave1_sel : coverpoint pkt.psel{
      
      bins slave1 = {2'b01};
      ignore_bins slave2 = {2'b10};
      illegal_bins invalid = {2'b11};
    }
    
    slave_1_adr : coverpoint pkt.padr iff (pkt.psel == 2'b01) {
      
      bins reg_0 = {5'h00};
      bins reg_1 = {5'h01};
      bins reg_2 = {5'h02};
      bins reg_4 = {5'h03};
      bins error = {5'h04};
      
      illegal_bins wrong_adr = {[5'h05 : 5'h1f]};
    }
    
    slave_1_write : coverpoint pkt.pwrite iff (pkt.psel == 2'b01) {
      
      bins write = {1'b1};
      bins read = {1'b0};
      
    }
    
    slave_1_pslverr : coverpoint pkt.pslverr iff (pkt.psel == 2'b01) {
      
      bins no_err = {1'b0};
      bins error = {1'b1};
      
    }
    
    cross_adr : cross slave1_sel , slave_1_adr;
    cross_write : cross slave1_sel , slave_1_write;
    cross_adr_X_write : cross slave_1_write, slave_1_adr;
    cross_write_X_pslverr : cross slave_1_write, slave_1_pslverr;
    
  endgroup
  
    covergroup slave_2;
    
    slave2_sel : coverpoint pkt.psel{
      
      ignore_bins slave1 = {2'b01};
      bins slave2 = {2'b10};
      illegal_bins invalid = {2'b11};
    }
    
      slave_2_adr : coverpoint pkt.padr iff (pkt.psel == 2'b10) {
      
        bins mem = {[5'h00 : 5'h1E]};
        bins wrong_mem = {5'h1f};
 
    }
    
      slave_2_write : coverpoint pkt.pwrite iff (pkt.psel == 2'b10) {
      
      bins write = {1'b1};
      bins read = {1'b0};
      
    }
    
      slave_2_pslverr : coverpoint pkt.pslverr iff (pkt.psel == 2'b10) {
      
      bins no_err = {1'b0};
      bins error = {1'b1};
      
    }
      
    cross_adr : cross slave2_sel , slave_2_adr;
    cross_write : cross slave2_sel , slave_2_write;
    cross_adr_X_write : cross slave_2_write, slave_2_adr;
    cross_write_X_pslverr : cross slave_2_write, slave_2_pslverr;
      
  endgroup
  
  function new(string path = "cvrg_col",uvm_component parent = null);
    super.new(path,parent);
    slave_1 = new();
    slave_2 = new();
  endfunction
  
  virtual function void write(packet t);

    pkt = t;
    slave_1.sample();
    slave_2.sample();
    
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    
    super.report_phase(phase);
    `uvm_info("cvrg_col",$sformatf("slave 1 Functional Coverage = %0.2f%%",slave_1.get_inst_coverage()),UVM_NONE);
    `uvm_info("cvrg_col",$sformatf("slave 2 Functional Coverage = %0.2f%%",slave_2.get_inst_coverage()),UVM_NONE);
    
  endfunction
  
endclass


    
      
