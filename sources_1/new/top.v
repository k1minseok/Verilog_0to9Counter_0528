`timescale 1ns / 1ps

module top (
    input clk,
    input reset,

    output [7:0] fndFont,
    output [3:0] fndCom
);
    wire [7:0] w_outcount;

    DedicatedProcessor U_DP (
        .clk  (clk),
        .reset(reset),

        .out(w_outcount)
    );


    fndContorller U_FNDController (
        .reset(reset),
        .clk  (clk),
        .digit({6'b0, w_outcount}),

        .fndFont(fndFont),
        .fndCom (fndCom)

    );

endmodule
