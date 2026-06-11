module fcover (
  input  logic         clk_i,
  input  logic         rst_ni,
  input  logic         enable_i,
  input  logic [N-1:0] count_o
);

covergroup sync_cov@(posedge clk_i);
//enable activado y desactivado 
    sc_enable : coverpoint enable_i {
        bins en_enabled = {1'b1};
        bins en_disabled = {1'b0};
    }

    // Conteo
    sc_count : coverpoint count_o {
    bins zero         = {4'b0};
    bins intermediate = {[1:14]};
    bins maximum      = {4'hf};
    }
    sc_rst :   coverpoint  rst_ni   {
        bins    res_enabled     =   {1'b0};
        bins    res_disabled    =   {1'b1};
    }

endgroup

//Conteo desde 0 hasta valor intermedio
cv_count_zero_mid  : cover property (@(posedge clk_i) count_o == 0 ##[1:$] count_o == 5);

//Conteo desde valor intermedio hasta maximo
cv_count_mid_max : cover property (@(posedge clk_i) count_o == 5 ##[1:$] count_o == 15);

//Transición de maximo a 0 (wraparound)
cv_wraparound : cover property (@(posedge clk_i) (enable_i && count_o == 15) |=> count_o == 0);

//Aplicación de reset desde un valor arbitrario
cv_reset : cover property (@(posedge clk_i) count_o != 0 ##1 !rst_ni);

//Conteo continuo durante multiples ciclos
cv_count : cover property (
  @(posedge clk_i)
  enable_i && count_o == 0
  ##1 count_o == 1
  ##1 count_o == 2
  ##1 count_o == 3
  ##1 count_o == 4
);

sync_cov sync_cov_data = new();

endmodule