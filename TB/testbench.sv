`include "TEST/ENVIRONMENT/AGENT/packet.sv"
`include "TEST/ENVIRONMENT/cvrg_col.sv"
`include "TEST/ENVIRONMENT/AGENT/seqr.sv"
`include "TEST/sequences.sv"
`include "TEST/ENVIRONMENT/AGENT/driver.sv"
`include "TEST/ENVIRONMENT/AGENT/monitor.sv"
`include "TEST/ENVIRONMENT/scoreboard.sv"
`include "TEST/ENVIRONMENT/AGENT/agent.sv"
`include "TEST/ENVIRONMENT/env.sv"
`include "TEST/test.sv"
`include "interface.sv"

import uvm_pkg::*;

module tb;
  
  apb_if aif();
  
  logic pready1,pslverr1;
  logic pready2,pslverr2;
  logic psel1,psel2;
  
  logic [31:0] prdata1,prdata2;
  
  
  APB_slave1 s1( .pclk(aif.pclk),
              .presetn(aif.presetn),
              .padr(aif.padr),
                .psel(psel1),
              .pwrite(aif.pwrite),
              .penable(aif.penable),
              .pwdata(aif.pwdata),
              
                .prdata(prdata1),
                .pready(pready1),
                .pslverr(pslverr1) );
  
  APB_slave2 s2( .pclk(aif.pclk),
              .presetn(aif.presetn),
              .padr(aif.padr),
                .psel((psel2)),
              .pwrite(aif.pwrite),
              .penable(aif.penable),
              .pwdata(aif.pwdata),
              
                .prdata(prdata2),
                .pready(pready2),
                .pslverr(pslverr2) );
  
 
  assign psel1 = aif.psel[0];
  assign psel2 = aif.psel[1];
  assign aif.prdata = psel1 ? prdata1 : prdata2;
  assign aif.pready = psel1 ? pready1 : pready2;
  assign aif.pslverr = psel1 ? pslverr1 : pslverr2;
  
  initial
    begin
      aif.pclk =0;   
      forever #5 aif.pclk = ~aif.pclk;
      
      
    end
  
  initial 
    begin
      
      uvm_config_db #(virtual apb_if) :: set (null,"*","aif",aif);
      run_test("test");
    end
  
endmodule
      
  
  
