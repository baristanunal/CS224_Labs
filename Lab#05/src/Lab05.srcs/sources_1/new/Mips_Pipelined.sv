`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Barýþ Tan Ünal
// 
// Create Date: 13.04.2022 14:07:04
// Design Name: 
// Module Name: Mips_Pipelined
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


// Define pipes that exist in the PipelinedDatapath. 
// The pipe between Writeback (W) and Fetch (F), as well as Fetch (F) and Decode (D) is given to you.
// Create the rest of the pipes where inputs follow the naming conventions in the book.


module PipeFtoD(input logic[31:0] instr, PcPlus4F,
                input logic EN, clear, clk, reset,
                output logic[31:0] instrD, PcPlus4D);

                always_ff @(posedge clk, posedge reset)
                  if(reset)
                        begin
                        instrD <= 0;
                        PcPlus4D <= 0;
                        end
                    else if(EN)
                        begin
                          if(clear) // Can clear only if the pipe is enabled, that is, if it is not stalling.
                            begin
                        	   instrD <= 0;
                        	   PcPlus4D <= 0;
                            end
                          else
                            begin
                        		instrD<=instr;
                        		PcPlus4D<=PcPlus4F;
                            end
                        end
                
endmodule

// Similarly, the pipe between Writeback (W) and Fetch (F) is given as follows.

module PipeWtoF(input logic[31:0] PC,
                input logic EN, clk, reset,		// ~StallF will be connected as this EN
                output logic[31:0] PCF);

                always_ff @(posedge clk, posedge reset)
                    if(reset)
                        PCF <= 0;
                    else if(EN)
                        PCF <= PC;
endmodule


module PipeDtoE(input logic[31:0] RD1, RD2, RD3, SignImmD,
                input logic[4:0] RsD, RtD, RdD,
                input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, WriteMuxD,
                input logic[2:0] ALUControlD,
                input logic clear, clk, reset,
                output logic[31:0] RsData, RtData, RdData, SignImmE,
                output logic[4:0] RsE, RtE, RdE, 
                output logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, WriteMuxE,
                output logic[2:0] ALUControlE);

        always_ff @(posedge clk, posedge reset)
          if(reset || clear)
                begin
                // Control signals
                RegWriteE <= 0;
                MemtoRegE <= 0;
                MemWriteE <= 0;
                ALUControlE <= 0;
                ALUSrcE <= 0;
                RegDstE <= 0;
                WriteMuxE <= 0;
                
                // Data
                RsData <= 0;
                RtData <= 0;
                RdData <= 0;
                RsE <= 0;
                RtE <= 0;
                RdE <= 0;
                SignImmE <= 0;
                end
            else
                begin
                // Control signals
                RegWriteE <= RegWriteD;
                MemtoRegE <= MemtoRegD;
                MemWriteE <= MemWriteD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                RegDstE <= RegDstD;
                WriteMuxE <= WriteMuxD;
                
                // Data
                RsData <= RD1;
                RtData <= RD2;
                RdData <= RD3;
                RsE <= RsD;
                RtE <= RtD;
                RdE <= RdD;
                SignImmE <= SignImmD;
                end

endmodule


module PipeEtoM( input logic[31:0] ALUOutE, WriteDataE,
                 input logic[4:0] WriteRegE,
                 input logic RegWriteE, MemtoRegE, MemWriteE,
                 input logic clk, reset,
                 output logic[31:0] ALUOutM, WriteDataM,
                 output logic[4:0] WriteRegM,
                 output logic RegWriteM, MemtoRegM, MemWriteM );

    always_ff @ (posedge clk, posedge reset)
        if( reset )
            begin
                // Control signals
                RegWriteM <= 0;
                MemtoRegM <= 0;
                MemWriteM <= 0;
                
                // Data
                ALUOutM <= 0;
                WriteDataM <= 0;
                WriteRegM <= 0;
            end
        else
            begin
                 // Control signals
                RegWriteM <= RegWriteE;
                MemtoRegM <= MemtoRegE;
                MemWriteM <= MemWriteE;
                
                // Data
                ALUOutM <= ALUOutE;
                WriteDataM <= WriteDataE;
                WriteRegM <= WriteRegE;
            end    
    
endmodule


module PipeMtoW( input logic[31:0] ReadDataM, ALUOutM,
                 input logic[4:0] WriteRegM,
                 input logic RegWriteM, MemtoRegM,
                 input logic clk, reset,
                 output logic[31:0] ReadDataW, ALUOutW,
                 output logic[4:0] WriteRegW,
                 output logic RegWriteW, MemtoRegW );
                
     always_ff @ (posedge clk, posedge reset)
        if( reset )
            begin
                // Control signals
                RegWriteW <= 0;
                MemtoRegW <= 0;
                
                // Data
                ReadDataW <= 0;
                ALUOutW <= 0;
                WriteRegW <= 0;
            end
        else
            begin
                // Control signals
                RegWriteW <= RegWriteM;
                MemtoRegW <= MemtoRegM;
                
                // Data
                ReadDataW <= ReadDataM;
                ALUOutW <= ALUOutM;
                WriteRegW <= WriteRegM;
            end                     
               
endmodule


// *******************************************************************************
// End of the individual pipe definitions.
// ******************************************************************************

// *******************************************************************************
// Below is the definition of the datapath.
// The signature of the module is given. The datapath will include (not limited to) the following items:
//  (1) Adder that adds 4 to PC
//  (2) Shifter that shifts SignImmD to left by 2
//  (3) Sign extender and Register file
//  (4) PipeFtoD
//  (5) PipeDtoE and ALU
//  (5) Adder for PcBranchD
//  (6) PipeEtoM and Data Memory
//  (7) PipeMtoW
//  (8) Many muxes
//  (9) Hazard unit
//  ...?
// *******************************************************************************

module datapath (input  logic clk, reset,
                input  logic[2:0]  ALUControlD,
                input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD, WriteMuxD,
                 output logic [31:0] instrF,		
                 output logic [31:0] instrD, PC, PCF,
                output logic PcSrcD,                 
                output logic [31:0] ALUOutE, WriteDataE,
                output logic [1:0] ForwardAE, ForwardBE,
                 output logic ForwardAD, ForwardBD,
                 output logic[31:0] RD1, RD2, RD3,
                 output logic StallF, StallD, FlushE,
                 output logic[31:0] PcPlus4F, PcPlus4D ); // Add or remove input-outputs if necessary

	// ********************************************************************
	// Here, define the wires that are needed inside this pipelined datapath module
	// ********************************************************************
  
  	//* We have defined a few wires for you
    logic [31:0] PcSrcA, PcSrcB, PcBranchD;	
  
	//* You should define others down below
    logic[31:0] ShSignImmD, SignImmD, SignImmE;
    logic[31:0] ResultW;
    logic EqualD;
    logic[31:0] ReadDataM;
    logic[4:0] WriteRegW, WriteRegE, WriteRegM;
    
    logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE;
    logic RegWriteM, MemtoRegM, MemWriteM;
    logic RegWriteW, MemtoRegW;
    logic[2:0] ALUControlE;
    //logic StallF, StallD, FlushE;
    
    //logic[31:0] PcPlus4F, PcPlus4D;
    logic[4:0] RsD, RsE, RtD, RtE, RdD, RdE;
    logic[31:0] ALUOutM, ReadDataW, WriteDataM, ALUOutW;
    //logic[31:0] RD1, RD2;
    logic[31:0] muxOut1, muxOut2;
    logic[31:0] RsData, RtData, RdData;
    logic[31:0] SrcAE, SrcBE, WrDataSracc, ALUOutSelected;
  
	// ********************************************************************
	// Instantiate the required modules below in the order of the datapath flow.
	// ********************************************************************

  	//* We have provided you with some part of the datapath
    
  	// Instantiate PipeWtoF
  	PipeWtoF pipe1( PC,
                    ~StallF, clk, reset,
                    PCF);
  
  	// Do some operations
    adder addd ( PCF, 4, PcPlus4F );
  	mux2 #(32) pc_mux(PcPlus4F, PcBranchD, PcSrcD, PC);

    imem im1(PCF[7:2], instrF);
    
  	// Instantiate PipeFtoD
    PipeFtoD pipe2( instrF, PcPlus4F, ~StallD, PcSrcD, clk, reset, 
                    instrD, PcPlus4D );
  
  	// Do some operations
  	signext signExtend( instrD[15:0], SignImmD );
  	sl2 shifterLeft( SignImmD, ShSignImmD );
  	adder AdderPC( ShSignImmD, PcPlus4D, PcBranchD );
  	
  	regfile rf( clk, reset, RegWriteW,
  	            instrD[25:21], instrD[20:16], WriteRegW, 
  	            ResultW,
  	            RD1, RD2, RD3 );
  	            
  	mux2 #(32) muxRd1( RD1, ALUOutM, ForwardAD, muxOut1 ); 
  	mux2 #(32) muxRd2( RD2, ALUOutM, ForwardBD, muxOut2 ); 
  	
  	comparator comp( muxOut1, muxOut2, EqualD );
  	assign PcSrcD = EqualD & BranchD;
  	           
  
  	// Instantiate PipeDtoE
    PipeDtoE pipe3( RD1, RD2, RD3, SignImmD, 
                    instrD[25:21], instrD[20:16], instrD[15:11], 
                    RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, WriteMuxD,
                    ALUControlD, clear, clk, reset,
                    RsData, RtData, RdData, SignImmE,
                    RsE, RtE, RdE,
                    RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, WriteMuxE,
                    ALUControlE );
  
  	// Do some operations
    mux2 #(5) wregMux( RtE, RdE, RegDstE, WriteRegE );
    
    mux4 #(32) aluSrcMux1A( RsData, ResultW, ALUOutM, 32'b0,
                           ForwardAE,
                           SrcAE );
                           
    mux4 #(32) aluSrcMux1B( RtData, ResultW, ALUOutM, 32'b0,
                           ForwardBE,
                           WriteDataE );
                           
    mux2 #(32) aluSrcMux2( WriteDataE, SignImmE, ALUSrcE, SrcBE );
    
    alu ALU( SrcAE, SrcBE, ALUControlE, ALUOutE );
    
    adder #(32) adderSracc( RdData, ALUOutE, WrDataSracc);
    
    mux #(32) muxSracc( ALUOutE, WrDataSracc, WriteMuxE, ALUOutSelected );

  	// Instantiate PipeEtoM
    PipeEtoM pipe4( ALUOutSelected, WriteDataE,
              WriteRegE,
              RegWriteE, MemtoRegE, MemWriteE,
              clk, reset,
              ALUOutM, WriteDataM,
              WriteRegM,
              RegWriteM, MemtoRegM, MemWriteM );
  
  	// Do some operations
  	dmem dataMem( clk, MemWriteM, ALUOutM, WriteDataM, ReadDataM );

  	// Instantiate PipeMtoW
    PipeMtoW pipe5( ReadDataM, ALUOutM,
              WriteRegM,
              RegWriteM, MemtoRegM,
              clk, reset,
              ReadDataW, ALUOutW,
              WriteRegW,
              RegWriteW, MemtoRegW );
  
  	// Do some operations
  	mux2 #(32) muxResultSel( ALUOutW, ReadDataW, MemtoRegW, ResultW );
  	
 
  	HazardUnit hazardUnit( RegWriteW, BranchD,
                           WriteRegW, WriteRegE,
                           RegWriteM, MemtoRegM,
                           WriteRegM,
                           RegWriteE, MemtoRegE,
                           RsE, RtE,
                           instrD[25:21], instrD[20:16],
                           ForwardAE, ForwardBE,
                           FlushE, StallD, StallF, ForwardAD, ForwardBD );
  

endmodule


module HazardUnit( input logic RegWriteW, BranchD,
                input logic [4:0] WriteRegW, WriteRegE,
                input logic RegWriteM,MemtoRegM,
                input logic [4:0] WriteRegM,
                input logic RegWriteE,MemtoRegE,
                input logic [4:0] rsE,rtE,
                input logic [4:0] rsD,rtD,
                output logic [1:0] ForwardAE,ForwardBE,
                output logic FlushE, StallD, StallF, ForwardAD, ForwardBD
                 ); // Add or remove input-outputs if necessary
       
	// ********************************************************************
	// Here, write equations for the Hazard Logic.
	// If you have troubles, please study pages ~420-430 in your book.
	// ********************************************************************
    
    logic lwStall, branchStall;
    
    assign lwStall = ( ( (rsD == rtE) | (rtD == rtE) ) & MemtoRegE );
    
    assign branchStall = ( BranchD & RegWriteE & ( (WriteRegE == rsD) | (WriteRegE == rtD) )
                          | (BranchD & MemtoRegM & ( (WriteRegM == rsD) | (WriteRegM == rtD) ) ) );
    
    assign StallF = lwStall | branchStall;
    assign StallD = lwStall | branchStall;
    assign FlushE = lwStall | branchStall;
    
    //assign ForwardAD = (rsD != 0) & (rsD == WriteRegM) & RegWriteM;
    assign ForwardBD = (rtD != 0) & (rtD == WriteRegM) & RegWriteM;
    
    always_comb
        begin
        ForwardAD = (rsD != 0) & (rsD == WriteRegM) & RegWriteM;  
        
            if( ( rsE != 0 ) & ( rsE == WriteRegM ) & ( RegWriteM ) )
                begin
                    ForwardAE = 2'b10;
                end
            else if( ( rsE != 0 ) & ( rsE == WriteRegW ) & ( RegWriteW ) )
                begin
                    ForwardAE = 2'b01;
                end
            else
                begin
                    ForwardAE = 2'b00;
                end
        end
        
     always_comb
        begin
            if( ( rtE != 0 ) & ( rtE == WriteRegM ) & ( RegWriteM ) )
                begin
                    ForwardBE = 2'b10;
                end
            else if( ( rtE != 0 ) & ( rtE == WriteRegW ) & ( RegWriteW ) )
                begin
                    ForwardBE = 2'b01;
                end
            else
                begin
                    ForwardBE = 2'b00;
                end
        end   
          
    
    //assign ForwardAE[1] = (rsE != 0) & (rsE == WriteRegM) & (RegWriteM);
    //assign ForwardBE[1] = (rtE != 0) & (rtE == WriteRegM) & (RegWriteM);
    
    //assign ForwardAE[0] = (rsE != 0) & (rsE == WriteRegW) & (RegWriteW);
    //assign ForwardBE[0] = (rtE != 0) & (rtE == WriteRegW) & (RegWriteW);
  
endmodule


// You can add some more logic variables for testing purposes
// but you cannot remove existing variables as we need you to output 
// these values on the waveform for grading
module top_mips (input  logic clk, reset,
             output  logic[31:0] instrF,
             output logic[31:0] PC, PCF,
             output logic PcSrcD,
             output logic MemWriteD, MemtoRegD, ALUSrcD, BranchD, RegDstD, RegWriteD,
             output logic [2:0]  ALUControl,
             output logic [31:0] instrD, 
             output logic [31:0] ALUOutE, WriteDataE,
             output logic [1:0] ForwardAE, ForwardBE,
             output logic ForwardAD, ForwardBD,
             output logic [31:0] RD1, RD2,
             output logic StallF, StallD, FlushE,
             output logic[31:0] PcPlus4F, PcPlus4D );

	// ********************************************************************
	// Below, instantiate a controller and a datapath with their new (if modified) signatures
	// and corresponding connections.
	// ********************************************************************
    
    controller cntrl ( instrD[31:26], instrD[5:0],
                       MemtoRegD, MemWriteD, ALUSrcD, RegDstD, RegWriteD, 
                       ALUControl, 
                       BranchD );
                   
    datapath dpath ( clk, reset,
                     ALUControl,
                     RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
                     instrF,
                     instrD, PC, PCF,
                     PcSrcD,
                     ALUOutE, WriteDataE,
                     ForwardAE, ForwardBE,
                     ForwardAD, ForwardBD,
                     RD1, RD2,
                     StallF, StallD, FlushE,
                     PcPlus4F, PcPlus4D );               
  
endmodule


// External instruction memory used by MIPS
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output
// Modify it to test your own programs.

module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//
// 	***************************************************************************
//	Here, you can paste your own test cases that you prepared for the part 1-e.
//  An example test program is given below.        
//	***************************************************************************
//
//		address		instruction
//		-------		-----------
/*
       8'h00: instr = 32'h20080007;    // addi $t0, $zero, 7
       8'h04: instr = 32'h20090005;    // addi $t1, $zero, 5
       8'h08: instr = 32'h200a0000;    // addi $t2, $zero, 0
       8'h0c: instr = 32'h210b000f;    // addi $t3, $t0, 15
       8'h10: instr = 32'h01095020;    // add $t2, $t0, $t1 
       8'h14: instr = 32'h01095025;    // or $t2, $t0, $t1
       8'h18: instr = 32'h01095024;    // and $t2, $t0, $t1
       8'h1c: instr = 32'h01095022;    // sub $t2, $t0, $t1
       8'h20: instr = 32'h0109502a;    // slt $t2, $t0, $t1
       8'h24: instr = 32'had280002;    // sw $t0, 2($t1)
       8'h28: instr = 32'h8d090000;    // lw $t1, 0($t0)
       8'h2c: instr = 32'h1100fff5;    // beq $t0, $zero, 0xfff5
       8'h30: instr = 32'h200a000a;    // addi $t2, $zero, 10
       8'h34: instr = 32'h2009000c;    // addi $t1, $zero, 12 
       default:  instr = {32{1'bx}};	// unknown address
*/

/*
	   8'h00: instr = 32'h20080005;    // addi $t0, $zero, 5
       8'h04: instr = 32'h20090007;    // addi $t1, $zero, 7
       8'h08: instr = 32'h200a0002;    // addi $t2, $zero, 2
       8'h0c: instr = 32'h012a5025;    // or $t2, $t1, $t2
       8'h10: instr = 32'h01498024;    // and $s0, $t2, $t1 
       8'h14: instr = 32'h01108820;    // add $s1, $t0, $s0
       8'h18: instr = 32'h0151902a;    // slt $s2, $t2, $s1
       8'h1c: instr = 32'h02318820;    // add $s1, $s1, $s1
       8'h20: instr = 32'h02329822;    // sub $s3, $s1, $s2
       8'h24: instr = 32'had330074;    // sw $s3, 0x74($t1)
       8'h28: instr = 32'h8C020080;    // lw $v0, 0x80($zero)
       //8'h2c: instr = 32'h1100fff5;    // beq $t0, $zero, 0xfff5
       //8'h30: instr = 32'h200a000a;    // addi $t2, $zero, 10
       //8'h34: instr = 32'h2009000c;    // addi $t1, $zero, 12 
*/

/*
                8'h00: instr = 32'h20080005;  //addi $t0, $zero, 5    = 5
                8'h04: instr = 32'hAC080060;  //sw $t0, 0x60($zero)  
                8'h08: instr = 32'h8C090060;  //lw $t1, 0x60($zero)  = 5
                8'h0c: instr = 32'h21290000;  //addi $t1, $t1, 0 = 5  
*/

                8'h00: instr = 32'h20040005;  //addi $a0, $zero, 5  = 5
                8'h04: instr = 32'h2005000C;  //addi $a1, $zero, 12 = 12
                8'h08: instr = 32'h20060002;  //addi $a2, $zero, 2  = 2
                8'h0c: instr = 32'h2008000A;  //addi $t0, $zero, 10  = 10
                8'h10: instr = 32'h00A44824;  //and $t1, $a1, $a0  = 4 
                8'h14: instr = 32'h00855825;  //or $t3, $a0, $a1  = 13
                //hazard code
                8'h18: instr = 32'h20110005;  //addi $s1, $zero, 5 = 5   
                8'h1c: instr = 32'h02208020;  //add $s0, $s1, $zero = 5    
                8'h20: instr = 32'h2209000A;  //addi $t1, $s0, 10  = 15
                8'h24: instr = 32'h1d095021;  //sracc $t1, $t1, $s1  = 
                8'h28: instr = 32'h0131482A;  //slt $t1, $t1, $s1  = 
                              
                     
       default:  instr = {32{1'bx}};	// unknown address
              
	   endcase
endmodule


// 	***************************************************************************
//	Below are the modules that you shouldn't need to modify at all..
//	***************************************************************************

module controller(input  logic[5:0] op, funct,
                  output logic     memtoreg, memwrite,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic[2:0] alucontrol,
                  output logic branch,
                  output logic writeMux );

   logic [1:0] aluop;

   maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, aluop, writeMux);

   aludec  ad (funct, aluop, alucontrol);

endmodule

// External data memory used by MIPS single-cycle processor

module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite,
	              output logic[1:0] aluop,
	              output logic writeMux );
  logic [8:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop, writeMux} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 9'b110000100; // R-type
      6'b100011: controls <= 9'b101001000; // LW
      6'b101011: controls <= 9'b001010000; // SW
      6'b000100: controls <= 9'b000100010; // BEQ
      6'b001000: controls <= 9'b101000000; // ADDI
      6'b000111: controls <= 9'b110000101; // SRACC
      default:   controls <= 9'bxxxxxxxxx; // illegal op
    endcase
endmodule

module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic[2:0] alucontrol);
  always_comb
    case(aluop)
      2'b00: alucontrol  = 3'b010;  // add  (for lw/sw/addi)
      2'b01: alucontrol  = 3'b110;  // sub   (for beq)
      default: case(funct)          // R-TYPE instructions
          6'b100000: alucontrol  = 3'b010; // ADD
          6'b100010: alucontrol  = 3'b110; // SUB
          6'b100100: alucontrol  = 3'b000; // AND
          6'b100101: alucontrol  = 3'b001; // OR
          6'b101010: alucontrol  = 3'b111; // SLT
          6'b100001: alucontrol  = 3'b011; // SHL
          default:   alucontrol  = 3'bxxx; // ???
        endcase
    endcase
endmodule

module regfile (input    logic clk, reset, we3, 
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2, rd3);

  logic [31:0] rf [31:0];

  // three ported register file: read two ports combinationally
  // write third port on falling edge of clock. Register0 hardwired to 0.

  always_ff @(negedge clk)
     if (we3) 
         rf [wa3] <= wd3;
  	 else if(reset)
       for (int i=0; i<32; i++) rf[i] = {32{1'b0}};	

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ ra2] : 0;
  assign rd3 = (wa3 != 0) ? rf [wa3] : 0;

endmodule

module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result);
    
    always_comb
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b111: result = (a < b) ? 1 : 0;
            default: result = {32{1'bx}};
        endcase
    
endmodule

module adder (input  logic[31:0] a, b,
              output logic[31:0] y);
     
     assign y = a + b;
endmodule

module sl2 (input  logic[31:0] a,
            output logic[31:0] y);
     
     assign y = {a[29:0], 2'b00}; // shifts left by 2
endmodule

module signext (input  logic[15:0] a,
                output logic[31:0] y);
              
  assign y = {{16{a[15]}}, a};    // sign-extends 16-bit a
endmodule

// parameterized register
module flopr #(parameter WIDTH = 8)
              (input logic clk, reset, 
	       input logic[WIDTH-1:0] d, 
               output logic[WIDTH-1:0] q);

  always_ff@(posedge clk, posedge reset)
    if (reset) q <= 0; 
    else       q <= d;
endmodule


// paramaterized 2-to-1 MUX
module mux2 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1,  
              input  logic s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s ? d1 : d0; 
endmodule

// paramaterized 4-to-1 MUX
module mux4 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1, d2, d3,
              input  logic[1:0] s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s[1] ? ( s[0] ? d3 : d2 ) : (s[0] ? d1 : d0); 
endmodule

module comparator#(parameter N = 32)
                  ( input logic [N-1:0] a, b,
                    output logic eq );
    assign eq = ( a == b );
endmodule                    
                     