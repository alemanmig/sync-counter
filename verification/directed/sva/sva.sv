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
    
endproperty

  //rising_edge_assert: assert property (rising_edge)

endmodule
