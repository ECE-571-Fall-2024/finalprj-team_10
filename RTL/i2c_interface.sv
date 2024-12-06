module i2c_interface(CLK,RST,ACK,RW_EN,SCL,SDA,out,addr,R_data,DONE,SDA_read);
  
 //declaring the input and output variables
input CLK,RST,ACK,RW_EN;
  input [7:0] out;
  input [6:0] addr;
  
  output logic SCL;
  output logic SDA;
  input logic SDA_read;
  output logic [7:0]R_data;
  output logic DONE;

//internal variable declaration
  logic SDA_EN;         
  
  logic SCL_temp,SDA_temp,SDA_temp_read;
  logic [7:0] R_data_t;
  logic [7:0] addr_temp;
  
  int i;

//Enumeration of I2C states
  typedef enum{IDLE,write_start,write_addr,write_addr_ACK,write_data,
out_ACK,write_stop,read_addr,read_addr_ACK,read_data,read_data_ACK,read_stop}STATE_type;
STATE_type STATE;

  always_ff@(posedge CLK,posedge RST)
    begin
      if(RST==1'b1)
        begin
          SCL_temp<=1'b0;
          SDA_temp<=1'b0;
          DONE<=1'b0;
          STATE<=IDLE;
        end
  //state machine for I2C interface    
      else begin
        case(STATE)
          IDLE:          
            begin
              DONE<=1'b0;
              SDA_EN<=1'b1;
              SCL_temp<=1'b1;
              SDA_temp<=1'b1;
              
              STATE<=write_start;
            end
//Write_data to the memory 
          
          write_start:      
            begin
              SDA_temp<=1'b0;SCL_temp<=1'b1;
              addr_temp<={addr,RW_EN};
              STATE <= (ACK == 1'b1) ? write_data : write_addr_ACK;
            end
          
          
          write_addr:begin
            for(i=0;i<8;i++) begin
              SDA_temp<=addr_temp[i];
              @(posedge CLK);
            end
            STATE<=write_addr_ACK;
          end
          
          write_addr_ACK:
            begin
              STATE <= (ACK == 1'b1) ? write_data : write_addr_ACK;
            end
          
          write_data:
            begin
              for(i=0;i<=7;i++) begin
                SDA_temp<=out[i];
                @(posedge CLK);
              end
              STATE<=out_ACK;
            end
          
          out_ACK:
            begin
              if(ACK==1'b1)
                begin
                  STATE<=write_stop;
                  SDA_temp<=1'b0;
                  SCL_temp<=1'b1;
                end
              else begin
                STATE<=out_ACK;
              end
            end
          
          write_stop:begin
            SDA_temp<=1'b1;
            STATE<=IDLE;
            DONE<=1'b1;
          end

//read_data from the memory
          
          read_addr: begin
            for(i=0;i<8;i++) begin
              SDA_temp<=addr_temp[i];
              @(posedge CLK);
            end
            STATE<=read_addr_ACK;
          end
          
          read_addr_ACK:begin
            STATE <= (ACK == 1'b1) ? read_data : read_addr_ACK;
            SDA_EN <= (ACK == 1'b1) ? 1'b0 : SDA_EN;
          end
          
          read_data:begin
            for(i=0;i<=7;i++) begin
              STATE<=read_data;
              R_data[i]<=SDA_read;
            end
            STATE<=read_stop;
            SCL_temp<=1'b1;
            SDA_temp<=1'b0;
          end
          
          read_stop:begin
            SDA_temp<=1'b1;
            STATE<=IDLE;
            DONE<=1'b1;
          end
          
          default: STATE<=IDLE;
        
        endcase
      end
    
    end
// Assign clock and SDA line based on conditions
  assign SCL = ((STATE==write_start)||(STATE==write_stop)||(STATE==read_stop)) ? SCL_temp : CLK;
  
  assign SDA = (SDA_EN == 1'b1) ? SDA_temp: 1'bz;

  
  
endmodule
