`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2022 22:18:39
// Design Name: 
// Module Name: MipsPipe_testbench
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


module MipsPipe_testbench();

    //logic clk, reset, writedata[31:0], dataadr[31:0], pc[31:0], instr[31:0], readdata[31:0], memwrite;
    
    logic [31:0] instrF, PC, PCF, RD1, RD2;
    logic PcSrcD;
    logic MemWriteD, MemtoRegD, ALUSrcD, BranchD, RegDstD, RegWriteD, ForwardAD, ForwardBD;
    logic [2:0] ALUControl;
    logic [1:0] ForwardAE, ForwardBE;
    logic [31:0] instrD, ALUOutE, WriteDataE;
    logic clk, reset;
    logic StallF, StallD, FlushE;
    logic[31:0] PcPlus4F, PcPlus4D;
    
    top_mips dut( clk, reset, 
                  instrF,
                  PC, PCF,
                  PcSrcD,
                  MemWriteD, MemtoRegD, ALUSrcD, BranchD, RegDstD, RegWriteD,
                  ALUControl,
                  instrD,
                  ALUOutE, WriteDataE,
                  ForwardAE, ForwardBE,
                  ForwardAD, ForwardBD,
                  RD1, RD2,
                  StallF, StallD, FlushE,
                  PcPlus4F, PcPlus4D );
                  
    always
        begin
           clk = 1; #10; clk = 0; #10; 
        end    
        
     initial begin
        
        /*
        assign PcSrc = 0;
        assign MemWriteD = 0;
        assign MemtoRegD = 0; 
        assign ALUSrcD = 0;
        assign BranchD = 0;
        assign RegDstD = 0;
        assign RegWriteD = 0;
        assign ForwardAD = 0;
        assign ForwardBD = 0;
        
        
        for( int i = 0; i < 3; i++ )begin
            ALUControl[i] = 0;
        end
        
        for( int i = 0; i < 2; i++ )begin
            ForwardAE[i] = 0;
        end
        
        for( int i = 0; i < 2; i++ )begin
            ForwardBE[i] = 0;
        end
        
        for( int i = 0; i < 32; i++ )begin
            instrF[i] = 0;
        end
        
        for( int i = 0; i < 32; i++ )begin
            PC[i] = 0;
        end
        
        for( int i = 0; i < 32; i++ )begin
            PCF[i] = 0;
        end
        
        for( int i = 0; i < 32; i++ )begin
            instrD[i] = 0;
        end
        
        for( int i = 0; i < 32; i++ )begin
            ALUOutE[i] = 0;
        end
        
        for( int i = 0; i < 32; i++ )begin
            WriteDataE[i] = 0;
        end
        */
        
        reset = 1; #10;
        reset = 0; #10; 
     
     end       
     
     
              

endmodule
