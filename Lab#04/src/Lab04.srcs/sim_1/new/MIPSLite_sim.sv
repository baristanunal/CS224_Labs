`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2022 20:30:25
// Design Name: 
// Module Name: MIPSLite_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPSLite_sim();

    //logic clk, reset, writedata[31:0], dataadr[31:0], pc[31:0], instr[31:0], readdata[31:0], memwrite;
    logic [31:0] writedata, dataadr, pc, instr, readdata;
    logic clk, reset, memwrite;
    
    top dut( clk, reset, writedata[31:0], 
             dataadr[31:0], pc[31:0], instr[31:0], 
             readdata[31:0], memwrite );
    
     always
        begin
           clk = 1; #10; clk = 0; #10; 
        end
        
        
     initial begin
     
     for( int i = 0; i < 32; i++ )begin
        writedata[i] = 0;
     end
     
     for( int i = 0; i < 32; i++ )begin
        dataadr[i] = 0;
     end
     
     for( int i = 0; i < 32; i++ )begin
        pc[i] = 0;
     end
     
     for( int i = 0; i < 32; i++ )begin
        instr[i] = 0;
     end
     
     for( int i = 0; i < 32; i++ )begin
        readdata[i] = 0;
     end
     
     memwrite = 0;
     
     reset = 1; #10;
     reset = 0; #10;
     
     
     end
    
    
endmodule



