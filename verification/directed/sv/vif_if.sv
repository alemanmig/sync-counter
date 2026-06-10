`ifndef VIF_IF_SV
`define VIF_IF_SV

interface vif_if(
    input logic clk_i
);

  timeunit      1ns;
  timeprecision 100ps;

  import config_pkg::*;

  logic         rst_ni;
  logic         enable_i;
  logic [N-1:0] count_o;

endinterface : vif_if

`endif // VIF_IF_SV
