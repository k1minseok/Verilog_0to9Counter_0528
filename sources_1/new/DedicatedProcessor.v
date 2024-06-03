`timescale 1ns / 1ps

module DedicatedProcessor (
    input clk,
    input reset,

    output [7:0] out
);

    wire w_ASrcMuxSel, w_ALoad, w_OutBufSel, w_ALt10;
    reg r_clk;
    reg [31:0] counter;

    always @(posedge clk, posedge reset) begin      // prescaler
        if (reset) begin
            counter <= 0;
        end else begin
            // if (counter == 10_000_000 - 1) begin
            if (counter == 1) begin
                counter <= 0;
                r_clk   <= 1'b1;
            end else begin
                counter <= counter + 1;
                r_clk   <= 1'b0;
            end
        end
    end

    ControlUnit U_CU (
        .clk  (r_clk),
        .reset(reset),
        .ALt10(w_ALt10),

        .ASrcMuxSel(w_ASrcMuxSel),
        .ALoad(w_ALoad),
        .OutBufSel(w_OutBufSel)
    );


    DataPath U_DP (
        .clk(r_clk),
        .reset(reset),
        .ASrcMuxSel(w_ASrcMuxSel),
        .ALoad(w_ALoad),
        .OutBufSel(w_OutBufSel),

        .ALt10(w_ALt10),
        .out  (out)
    );

endmodule
