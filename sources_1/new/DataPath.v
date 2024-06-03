`timescale 1ns / 1ps

module DataPath (
    input clk,
    input reset,
    input ASrcMuxSel,
    input ALoad,
    input OutBufSel,

    output ALt10,
    output [7:0] out
);

    wire [7:0] w_AdderResult, w_MuxOut, w_ARegOut;

    mux_2x1 U_MUX (
        .sel(ASrcMuxSel),
        .a  (8'b0),
        .b  (w_AdderResult),

        .y(w_MuxOut)
    );

    register U_A_Reg (
        .clk(clk),
        .reset(reset),
        .load(ALoad),
        .d(w_MuxOut),

        .q(w_ARegOut)
    );

    comparator U_Comp (
        .a(w_ARegOut),
        .b(8'd10),

        .lt(ALt10)
    );

    adder U_Adder (
        .a(w_ARegOut),
        .b(8'b1),

        .y(w_AdderResult)
    );

    // outBuff U_OutBuf (
    //     .en(OutBufSel),
    //     .a (w_ARegOut),

    //     .y(out)
    // );

    register U_Out_Reg (
        .clk(clk),
        .reset(reset),
        .load(OutBufSel),
        .d(w_ARegOut),

        .q(out)
    );       

endmodule


module mux_2x1 (
    input [7:0] a,
    input [7:0] b,
    input sel,

    output reg [7:0] y
);

    always @(*) begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end
endmodule

module register (
    input clk,
    input reset,
    input load,
    input [7:0] d,
    output [7:0] q
);
    reg [7:0] d_reg, d_next;
    assign q = d_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) d_reg <= 0;
        else d_reg <= d_next;
    end

    always @(*) begin
        if (load) d_next = d;
        else d_next = d_reg;
    end
endmodule


module comparator (
    input [7:0] a,
    input [7:0] b,

    output lt
);
    assign lt = a < b;
endmodule


module adder (
    input [7:0] a,
    input [7:0] b,

    output [7:0] y
);
    assign y = a + b;
endmodule


module outBuff (
    input en,
    input [7:0] a,

    output [7:0] y
);
    assign y = en ? a : 8'bz;  // en이 1 -> a, en이 0 -> high impedence 
endmodule
