module comparator(
    input [31:0] a, b,
    output equal);

    assign equal = (a===b);
endmodule