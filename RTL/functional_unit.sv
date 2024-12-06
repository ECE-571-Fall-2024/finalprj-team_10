module functional_unit(out, m, n, sel);
  // ALU-like functional unit for arithmetic and logical operations
  // Input and output variable declarations
  input logic [3:0] m, n;         
  output logic [7:0] out;         
  input logic [3:0] sel;          

  // Function to perform the operation based on selector
  function logic [7:0] operations(
      input logic [3:0] m, 
      input logic [3:0] n, 
      input logic [3:0] sel
  );
    case (sel)
      4'd0: operations = m + n;        
      4'd1: operations = m - n;        
      4'd2: operations = m * n;        
      4'd3: operations = m & n;        
      4'd4: operations = m | n;        
      4'd5: operations = m ^ n;        
      4'd6: operations = m && n;       
      4'd7: operations = m || n;       
      4'd8: operations = ~m;           
      4'd9: operations = (3 * m) - n;  
      default: operations = 8'd0;      
    endcase
  endfunction

  // Always block calling the function to compute 'operations'
  always_comb begin
    out = operations (m, n, sel); // Function call
  end
endmodule
