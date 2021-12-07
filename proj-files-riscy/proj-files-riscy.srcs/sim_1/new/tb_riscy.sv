`timescale 1ns / 100ps

module tb_riscy;

reg clk;
reg rst;
reg [31:0] csr0_in;
wire [31:0] csr1;
localparam CLK_PERIOD = 10;

riscy RISCY(
    .CLK(clk),
    .RST(rst),
    .CSR0_IN(csr0_in),
    .CSR1(csr1)
);

initial begin
    clk <= 0;
    forever begin
        #(CLK_PERIOD/2) clk <= ~clk;
    end
end

initial begin
    rst <= 1;
    csr0_in <= 0;
    #CLK_PERIOD rst <= 0;
end


endmodule
