`default_nettype none
module sync_counter #(
  parameter int unsigned N = 4,
  parameter logic [N-1:0] ResetValue = '0
) (
  input  logic         clk_i,
  input  logic         rst_ni,
  input  logic         enable_i,
  output logic [N-1:0] count_o
);
covergroup sync_cov@(posedge clk_i);





endgroup

sync_cov sync_cov_data = new();
endmodule







`default_nettype wire