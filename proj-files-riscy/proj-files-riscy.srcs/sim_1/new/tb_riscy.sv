`timescale 1ns / 100ps

module tb_riscy;

reg gclk;
reg mrst;
reg [31:0] csr0_in;
wire [31:0] csr1;
localparam CLK_PERIOD = 10;
riscy RISCY(
    .GCLK(gclk),
    .MRST(mrst),
    .CSR0_IN(csr0_in),
    .CSR1(csr1)
);

initial begin
    gclk <= 0;
    forever begin
        #(CLK_PERIOD/2) gclk <= ~gclk;
    end
end

initial begin
    mrst <= 1;
    csr0_in <= 0;
    #CLK_PERIOD mrst <= 0;
end


endmodule
