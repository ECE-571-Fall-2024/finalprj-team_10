module memory(CLK,RST,addr,data,RW_EN,data_read);
  
  input logic CLK,RST;
  input logic RW_EN;
  
  input logic [6:0] addr;
  input logic [7:0] data;
  output logic [7:0] data_read;
  
  bit SDA_en=0;
  logic [7:0] mem[128];
  
  logic [7:0] addrin;
  logic [7:0] data_out;
  logic [7:0] temprd;
  logic sdar = 0;
  
  int i;
  
  always_ff@(posedge CLK,posedge RST) 
    begin
      if(RST==1'b1)
        begin
// Reset all memory locations to 0
          for(i=0;i<128;i++)  // 128x8 memory array
            mem[i] <= 0;
        end
      
      else begin
        if(RW_EN==1'b1)begin
          mem[addr]<=data;
	  mem[10]<=10;
end
        else
// Write data to memory at the given address
          data_out<=mem[addr];
      end
    end
 // Read data from memory at the given address
  assign data_read = data_out;
      
endmodule
