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
    reset();
    
    //set de tareas
    TC01();
    //TC02();
    //TC03();
    //TC04();
    //TC05();
    //Stimulus


    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst_ni = 1'b1;
    @(posedge vif.clk_i);   // hold for at least 2 rising edges
    @(posedge vif.clk_i);
    vif.rst_ni = 1'b0; // activo reset
    @(posedge vif.clk_i);
    vif.rst_ni = 1'b1; //libero reset
    @(posedge vif.clk_i);
  endtask : reset

  task automatic init();
    vif.rst_ni = 1'b1; //liberado
    vif.enable_i = 1'b0; //deshabilitado conteo
    @(posedge vif.clk_i);
  endtask : init 


  //task: conteo con enable activo
  task automatic TC01();
    init();
    vif.enable_i = 1'b1;  //habilito conteo
    repeat (10) @(posedge vif.clk_i);
  endtask : TC01

   //task: Retencion con enable desactivado 
  task automatic TC02();
    init();
    vif.enable_i = 1'b1; //habilito conteo 
    @(posedge vif.clk_i)
    @(vif.count_o == 'd10); // si la salida es 10 entonces
    vif.enable_i = 1'b0; //deshabilito conteo
    repeat (3) @(posedge vif.clk_i)
    vif.enable_i = 1'b1; //habilito nuevamente conteo 
  endtask : TC02

   //task: Wraparound
  task automatic TC03();
    init();
    vif.enable_i = 1'b1; 
    @(vif.count_o =='hf)
    @(posedge vif.clk_i);
    vif.enable_i = 1'b0;
  endtask : TC03

  //Verificar el reset asincrono
  task automatic TC04();
    init();
    vif.enable_i = 1'b1; //habilito conteo
    repeat (7) @(posedge vif.clk_i);

    vif.rst_ni = 1'b0; //activo reset
    #3;
    vif.rst_ni = 1'b1; //libero reset
    vif.enable_i = 1'b1;
  endtask : TC04 

  //conteo continuo
  task automatic TC05();
    init();
    vif.enable_i = 1'b1;
    repeat (30) @(posedge vif.clk_i);
    vif.enable_i = 1'b0; 
  endtask : TC05 


endmodule : test
