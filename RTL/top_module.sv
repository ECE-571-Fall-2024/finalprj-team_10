//top_module
module top_module(m,n,sel,CLK,RST,addr,RW_EN,R_data,DONE);
  input logic [3:0] m,n;
  input logic [3:0] sel;
  input bit CLK, RST;
  input [6:0] addr;
  input bit RW_EN;
  output logic [7:0] R_data;
  output DONE;
  
  logic [7:0] out;
  logic ACK;
  logic SCL;
  wire SDA;
  logic SDA_read;
  wire [7:0] data;
  logic [7:0] data_read;
  bit rw1;
  logic [6:0] addr1;

 //instantiation of all the modules 

  functional_unit funit(out, m, n, sel);
  
  i2c_interface i2c(CLK,RST,ACK,RW_EN,SCL,SDA,out,addr,R_data,DONE,SDA_read);
  
  memory_controller mem_ctrl(CLK,RST,ACK,SCL,SDA,addr1,data,rw1,SDA_read,data_read);
  
  memory mem(CLK,RST,addr1,data,rw1,data_read);
  
endmodule
