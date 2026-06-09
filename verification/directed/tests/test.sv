module test (
    vif_if vif
);
  // =================== DPI FUNCTIONS ==================== //
  //import "DPI-C" function real ref_model(real initial_value);

  // ================== GLOBAL VARIABLES ================== //

  import config_pkg::*;

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    // Initial values
    $display("Begin Of Simulation.");
//    get_config_args();
    //vif.count_o = 1'b0;
    // Apply reset
    //reset();
    
    //set de tareas
    TC01();
    TC02();
    //Stimulus


    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst_ni = 1'b1;
    //vif.sig_in_i  = 1'b0;
    @(posedge vif.clk_i);   // hold for at least 2 rising edges
    @(posedge vif.clk_i);
    vif.rst_ni = 1'b0;
  endtask : reset

  //task: conteo con enable activo
  task automatic TC01();
    vif.rst_ni = 1'b0; //aplico reset
    vif.enable_i = 1'b0;
    vif.count_o = 1'b0;
    @(posedge vif.clk_i); 
    vif.rst_ni = 1'b1; //libero reset
    vif.enable_i = 1'b1;
    repeat (10) @(posedge vif.clk_i);
  endtask : TC01

   //task: Retencion con enable desactivado 
  task automatic TC02();
    vif.rst_ni = 1'b1; //libero reset
    //vif.count_o = 4'ha;
    vif.enable_i = 1'b0;
    #20;
    vif.enable_i = 1'b1;
  endtask : TC02


endmodule : test
