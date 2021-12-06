//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2021 03:13:28 PM
// Design Name: 
// Module Name: tb_alu
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
`timescale 1ns / 100ps

module tb_alu;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] sel;
    wire [31:0] c;
    wire eq;
    wire ne;
    wire lt;
    wire ltu;
    wire ge;
    wire geu;
    
    localparam DELAY = 10;
    
    alu uut (
        .A(a),
        .B(b),
        .SEL(sel),
        .C(c),
        .EQ(eq),
        .NE(ne),
        .LT(lt),
        .LTU(ltu),
        .GE(ge),
        .GEU(geu)
    );

    initial begin
        a <= 10;
        b <= -5;
    end

    initial begin
        sel <= 0;
        for (int i = 1; i < 16; i++ ) begin
            #DELAY sel <= i;
        end
    end
    
endmodule
