interface apb_if;

    logic         pclk;
    logic         presetn;

    logic [4:0]   padr;
    logic [1:0]   psel;
    logic         pwrite;
    logic         penable;

    logic [31:0]  pwdata;

    logic [31:0]  prdata;
    logic         pready;
    logic         pslverr;
  
    logic psel1,psel2;
  assign psel1 = psel[0];
  assign psel2 = psel[1];
  
  property setup_to_access_1 ;
    @(posedge pclk ) disable iff(!presetn)
    (psel1 & !penable) |-> ##1 (penable);
  endproperty
  
  property setup_to_access_2 ;
    @(posedge pclk ) disable iff(!presetn || $isunknown(pwdata))
    (psel2 & !penable) |-> ##1 (penable);
  endproperty
  
  set_to_access_1 : assert property ( setup_to_access_1) 
    else `uvm_error("APB_IF","For Slave 1 set to access phase transition error");
    
    set_to_access_2 : assert property ( setup_to_access_2)
      else `uvm_error("APB_IF","For Slave 2 set to access phase transition error");
  
  property psel1_stable_during_transfer;
    @(posedge pclk) disable iff (!presetn)
    (psel1 && penable && !pready) |-> ##1 psel1 && $stable(padr);
  endproperty
     
  ast_psel1_stable: assert property(psel1_stable_during_transfer)
    else `uvm_error("APB_IF","Psel and padr is no stable")
      
  property psel2_stable_during_transfer;
    @(posedge pclk) disable iff (!presetn)
      (psel2 && penable && !pready) |-> ##1 psel2 && $stable(padr);
  endproperty

  ast_psel2_stable: assert property(psel2_stable_during_transfer)
    else `uvm_error("APB_IF","Psel and padr is no stable");
    
    property enable;
      @(posedge pclk) disable iff(!presetn)
      penable |-> psel1 || psel2;
    endproperty
    
    ast_enable: assert property(enable)
      else `uvm_error("APB_IF","Enable is high despite psel is low");
      
      property illegel_state;
        @(posedge pclk) disable iff(!presetn)
       presetn |=> ##2 $countones(~psel) != 0;
      endproperty
      
      ast_illegel_state : assert property(illegel_state)
        else `uvm_error("APB_IF","Illegel state error psel = 11");
    
  property is_x_psel;
    @(posedge pclk) disable iff(!presetn)
    presetn |=> ##2 ~$isunknown(psel);
  endproperty
    
    ast_is_x_psel: assert property (is_x_psel)
      else `uvm_error("APB_IF","psel is unknown");
      
  property is_x_pwrite;
    @(posedge pclk) disable iff(!presetn)
    presetn |=> ##3 ~$isunknown(pwrite);
  endproperty
      
     ast_is_x_pwrite: assert property (is_x_pwrite)
        else `uvm_error("APB_IF","pwrite is unknown");
       
  property is_x_pwdata;
    @(posedge pclk) disable iff(!presetn)
    presetn |=> ##3 ~$isunknown(pwdata);
  endproperty
      
       ast_is_x_pwdata: assert property (is_x_pwdata)
         else `uvm_error("APB_IF","pwdata is unknown");
         
  property is_x_padr;
    @(posedge pclk) disable iff(!presetn)
    presetn |=> ##3 ~$isunknown(padr);
  endproperty
      
         ast_is_x_padr: assert property (is_x_padr)
           else `uvm_error("APB_IF","padr is unknown");
           
   property is_x_penable;
    @(posedge pclk) disable iff(!presetn)
     presetn |=> ##2 ~$isunknown(penable);
  endproperty
      
           ast_is_x_penable: assert property (is_x_penable)
             else `uvm_error("APB_IF","penable is unknown");

endinterface
