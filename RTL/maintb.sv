package random_value_pkg;
class random_value;
// Randomized input values for testing
  rand logic [3:0] m_rand;
  rand logic [3:0] n_rand;
  randc logic [3:0] sel_rand;
  rand logic [6:0] addr_rand; 
 // Constraint to ensure the selector is within valid operation range
  constraint sel_c { sel_rand inside {[0:7]}; }
  
endclass
endpackage

module testbench_tb;
  import random_value_pkg::*;
  
  logic [3:0] m,n;
  logic [3:0] sel;
  bit CLK, RST;
  logic [6:0] addr;
  bit RW_EN;
  
  logic [7:0] R_data;
  logic DONE;

 
  // Random input object for generating test inputs
  random_value ran1;
 
//instantiate the memory controller module 
  top_module DUT (m,n,sel,CLK,RST,addr,RW_EN,R_data,DONE);
  
// Define a coverage group to monitor input values during simulation
  covergroup covgrp @(posedge CLK);
    //option.per_instance = 1;
    m : coverpoint m {
      bins range[] = {[0:8]};									
    }
    n : coverpoint n {
      bins range[] = {[0:8]};									
    }
    sel : coverpoint sel {
      bins range[] = {[0:7]};									//sel defined only from 0 to 9
    }
  endgroup
 
  covgrp covgrp_inst;
  
  
  // clock generation
  always
    begin  #12 CLK=~CLK;
    end 
  
  initial 
    begin
// Initialize and print coverage details after simulation
      covgrp_inst = new();
      #900
      $display("Coverage for sel = %0.2f %%", covgrp_inst.sel.get_coverage());
    end
	
  // starting the module
  initial begin
  	$dumpfile("dump.vcd");
    $dumpvars();
  
	  CLK=0;
	  RST=1;
    repeat (8) @(negedge CLK);
    RST = 0;
    @(negedge CLK);
 // Initialize the random input object and generate random values
  	ran1 = new();
  
  	assert (ran1.randomize());
    //m = ran1.m_rand;
  	//n = ran1.n_rand;
  	//sel = ran1.sel_rand;
    m = 6;
    n = 9;
    sel =3;
  	$display("m=%d, n=%d, sel=%d, addr=%h", ran1.m_rand,ran1.n_rand,ran1.sel_rand,ran1.addr_rand);
  
    @(negedge CLK);
	  addr=15;
	  RW_EN=1;
  	

  
  	@(posedge DONE);
  
  
  	$display("Time=%t", $time);
  	$display("Results of the functional unit:%b",DUT.funit.out);  
  	$display("RW=%d, Address : %h, Data in the memory:%b", RW_EN, addr, DUT.mem.mem[addr]);
  
  
  
  	//@(negedge CLK);
	  RW_EN=0;
	  addr = 15;
     
    @(negedge CLK);


 repeat (8) @(posedge CLK);
    //m = ran1.m_rand;
    //n = ran1.n_rand;
    //sel = ran1.sel_rand;
    m= 7;
    n= 4;
    sel= 0;
    repeat(8) @(posedge CLK);
    assert (ran1.randomize());
  	$display("m=%d, n=%d, sel=%d, addr=%h", ran1.m_rand,ran1.n_rand,ran1.sel_rand,ran1.addr_rand);
      
      @(negedge CLK);
      RW_EN =1;
      addr = 20;

  	  @(posedge DONE);
  
  	  $display("Time=%t", $time);
  	  $display("Results of the functional unit:%b",DUT.funit.out);  
  	  $display("RW=%d, Address : %h, Data in the memory:%b", RW_EN, addr, DUT.mem.mem[addr]);
  
  	
  
  
  
  	//addr=ran1.addr_rand;
	    @(negedge CLK);
      RW_EN=0;
      addr=20;

	/*repeat (4) @(posedge CLK);
  	RST=0;
  	m = ran1.m_rand;
  	n = ran1.n_rand;
  	sel = ran1.sel_rand;
    //DUT.mem.mem[addr] = 8'b10001011;

  	@(posedge DONE);
  
  	$display("Time=%t", $time);
  	$display("Results of the functional unit:%n",DUT.funit.out);  
  	$display("RW_EN=%d, Address : %h, Output Data:%n", RW_EN, addr, DUT.data_read); */
  
  	#80 $finish;
end
endmodule
