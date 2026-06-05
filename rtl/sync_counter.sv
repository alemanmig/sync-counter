module sync_counter #(
  parameter int unsigned N = 4,
  parameter logic [N-1:0] ResetValue = '0
) (
  input  logic         clk_i,
  input  logic         rst_ni,
  input  logic         enable_i,
  output logic [N-1:0] count_o
);

  logic [N-1:0] count_d, count_q;

  always_comb begin
    count_d = count_q;

    if (enable_i) begin
      count_d = count_q + 1'b1;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      count_q <= ResetValue;
    end else begin
      count_q <= count_d;
    end
  end

  assign count_o = count_q;

endmodule
