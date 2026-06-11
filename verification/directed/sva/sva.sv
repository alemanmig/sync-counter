import config_pkg::*;
module sva (
    // Interface signals
    input logic         clk_i,
    input logic         rst_ni,
    input logic         enable_i,
    input logic [N-1:0] count_o
);



//Conteo con enable activo
property p_tc01;
    @(posedge clk_i)
      disable iff(!rst_ni)
        $rose(enable_i) && count_o == 0 |-> ##3 (count_o == 3);
endproperty

//Retención con enable desactivado
property p_tc02;
    @(posedge clk_i)
      disable iff(!rst_ni)
          (!enable_i) |=>(count_o == $past(count_o));
endproperty

//wraparound
property p_tc03;
    @(posedge clk_i)
      disable iff(!rst_ni)
          (enable_i && count_o == 4'hf) |=> (count_o == 4'h0);
endproperty

//Reset
property p_tc04_hold_reset;
    @(posedge clk_i)
      !rst_ni |-> count_o == 0;
endproperty

property p_tc04_after_reset;
    @(posedge clk_i)
     $rose(rst_ni) |-> (count_o == 0);
endproperty

property p_tc04_reset_enable;
    @(posedge clk_i)
      disable iff(!rst_ni)
        count_o == 0 && $rose(enable_i) |=> (count_o == 1);
endproperty

//Conteo continuo
property p_tc05;
    @(posedge clk_i) 
      disable iff(!rst_ni)
        enable_i |=> count_o == ($past(count_o) + 1) % 16;
endproperty



p_tc01_assert: assert property(p_tc01)
  $info ("conteo correcto");
  else 
  $error("Error: Conteo con enable activo");

p_tc02_assert: assert property(p_tc02)
  $info ("conteo correcto");
  else 
  $error("Error: Retención con enable desactivado");

p_tc03_assert: assert property(p_tc03)
  $info ("conteo correcto");
  else 
  $error("Error: wraparound");

p_tc04_hold_reset_assert: assert property(p_tc04_hold_reset)
  $info ("conteo correcto");
  else 
  $error("Error: Hold_reset");

p_tc04_after_reset_assert: assert property(p_tc04_after_reset)
  $info ("conteo correcto");
  else 
  $error("Error: After_reset");

p_tc04_reset_enable_assert: assert property(p_tc04_reset_enable)
  $info ("conteo correcto");
  else 
  $error("Error: detección de conteo erróneo");

p_tc05_assert: assert property (p_tc05)
  $info ("conteo correcto");
  else 
  $error("Error: conteo continuo");


endmodule
