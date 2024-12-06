module memory_controller(CLK,RST,ACK,SCL,SDA,addr,data,RW_EN,SDA_read,data_read);
  //declaration of the input and output signals
  input logic CLK,RST;
  input logic SCL;
  input wire SDA;
  output wire SDA_read;
  
  output logic ACK;
  output logic [6:0] addr;
  output wire [7:0] data;
  input wire [7:0] data_read;
  output bit RW_EN;
  //internal signals of memory-conroller
  bit SDA_EN;
  logic [7:0] addrin;
  logic [7:0] datain;
  logic [7:0] temprd;
  logic sdar;
  
  int i;
//Enumeration of the states
  typedef enum{start,store_addr,ACK_addr,store_data,
               ACK_data,stop,send_data}STATE_type;
STATE_type STATE;

  always_ff@(posedge CLK,posedge RST) 
    begin
      if(RST==1'b1)
        begin
          addrin<=1'b0;
          //data<=1'b0;
          RW_EN<=1'b0;
          SDA_EN<=1'b0;
        end
  // State machine for memory controller    
      else begin
        case(STATE)
          start:					
            begin
              SDA_EN<=1'b1;
              STATE <= store_addr;
            end
          
          store_addr:
            begin
              SDA_EN<=1'b1;
               @(posedge CLK);
              for(i=0;i<=7;i++) begin
                @(posedge CLK);
                addrin[i] <= SDA;
                
            end
             STATE<=ACK_addr;
              RW_EN <= addrin[0];
                end
          
          
          ACK_addr:begin
            ACK <= 1'b1;
            if(RW_EN == 1'b1) begin
            STATE<=store_data;
              SDA_EN<=1'b1;
          end
            else begin
              STATE<=send_data;
              SDA_EN<=1'b0;
            end
          end
          
          store_data:
            begin
              ACK <= 1'b0;
              @(posedge CLK);
              for(i=0;i<=7;i++) begin
                 @(posedge CLK);
                datain[i] <= SDA;
               
              end
                  STATE<=ACK_data;
                end
          
          ACK_data: begin
            ACK <= 1'b1;
          STATE<=stop;
          end
          
          stop:begin
            ACK <= 1'b0;
            SDA_EN <= 1'b1;
            @(posedge CLK)
            @(posedge CLK)
            @(posedge CLK)
              STATE<=start;
          end
          
          send_data:begin
            SDA_EN <= 1'b0;
            for(i=0;i<=7;i++) begin
              sdar <= data_read[i];
            end
            STATE<=stop;
            SDA_EN <= 1'b1;
          end
          
          default: STATE<=start;
        
        endcase
      end
    
    end
  
  assign addr = addrin[7:1];
  assign SDA = (SDA_EN == 1'b1) ? 1'bz : sdar;
  assign SDA_read = sdar;
  assign data = (RW_EN == 1'b1) ? datain : 1'bz;

  

endmodule

