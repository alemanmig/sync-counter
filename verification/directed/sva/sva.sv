import config_pkg::*;
module sva (
    // Interface signals
    input logic         clk_i,
    input logic         rst_ni,
    input logic         enable_i,
    input logic [N-1:0] count_o
);

property p_tc01;
    @(posedge clk_i) 
    vif.enable_i |=> vif.count_o == $past(vif.count_o) + 1;
endproperty

  //rising_edge_assert: assert property (rising_edge)
p_tc01_assert: assert property (p_tc01)
  $info ("conteo correcto");
  else 
  $error("Error: detección de conteo erróneo");

endmodule
