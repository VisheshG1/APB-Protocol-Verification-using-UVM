`include "uvm_macros.svh"

import uvm_pkg ::*;


class reset_seq  extends uvm_sequence #(packet);
  
  `uvm_object_utils(reset_seq)
  packet pkt;
  
  function new(string path = "reset_seq");
    super.new(path);
  endfunction
  
  virtual task body();
    
    pkt = packet :: type_id :: create("pkt");
    
   /*start_item(pkt);
    pkt.presetn = 1;
    finish_item(pkt);
*/
    start_item(pkt);
    pkt.presetn = 0;
    finish_item(pkt);

    start_item(pkt);
    pkt.presetn = 1;
    finish_item(pkt);
  endtask
endclass

  
class seq_slave1_write extends uvm_sequence #(packet);
  
  `uvm_object_utils(seq_slave1_write);
  packet pkt;
  
  function new ( string path = "seq_slave1_write");
    super.new(path);
  endfunction
  
  virtual task body();
    
    pkt = packet :: type_id :: create("pkt");
    
    repeat (15) begin
      
      start_item(pkt);
      
      pkt.pwrite = 1'b1;
      pkt.psel = 2'b01;
      pkt.penable = 1'b1;
      pkt.presetn =1'b1;
      pkt.randomize();
      
      finish_item(pkt);
      
    end
    
  endtask
endclass
      
class seq_slave1_read extends uvm_sequence #(packet);
  
  `uvm_object_utils(seq_slave1_read);
  packet pkt;
  
  function new ( string path = "seq_slave1_read");
    super.new(path);
  endfunction
  
  virtual task body();
    
    pkt = packet :: type_id :: create("pkt");
    
    repeat (15) begin
      
      start_item(pkt);
      
      pkt.pwrite = 1'b0;
      pkt.psel = 2'b01;
      pkt.penable = 1'b1;
      pkt.presetn <=1'b1;
      pkt.randomize();
      
      finish_item(pkt);
      
     // pkt.print();
    end
    
  endtask
endclass

class seq_slave2_write extends uvm_sequence #(packet);
  
  `uvm_object_utils(seq_slave2_write);
  packet pkt;
  
  function new ( string path = "seq_slave2_write");
    super.new(path);
  endfunction
  
  virtual task body();
    
    pkt = packet :: type_id :: create("pkt");
    
    repeat (40) begin
      
      start_item(pkt);
      
      pkt.pwrite = 1'b1;
      pkt.psel = 2'b10;
      pkt.penable = 1'b1;
      pkt.presetn <=1'b1;
      pkt.randomize();
      
      finish_item(pkt);
      
      //pkt.print();
    end
    
  endtask
endclass

class seq_slave2_read extends uvm_sequence #(packet);
  
  `uvm_object_utils(seq_slave2_read);
  packet pkt;
  
  function new ( string path = "seq_slave2_read");
    super.new(path);
  endfunction
  
  virtual task body();
    
    pkt = packet :: type_id :: create("pkt");
    
    repeat (40) begin
      
      start_item(pkt);
      
      pkt.pwrite = 1'b0;
      pkt.psel = 2'b10;
      pkt.penable = 1'b1;
      pkt.presetn <=1'b1;
      pkt.randomize();
      
      finish_item(pkt);
      
      //pkt.print();
    end
    
  endtask
endclass
      
